library(clue)
library(dplyr)
library(magrittr)
library(ggplot2)

setwd('/Users/timlew/Documents/github_private/iterated_learning_analyses')

dat = read.csv2('data/dots_memory.csv', sep=',')

dat$x = as.numeric(as.character(dat$x))
dat$y = as.numeric(as.character(dat$y))

RECALC = FALSE


RMSE.trial = function(seed, resp){
  d.1 = function(i){(seed$x[i]-resp$x)^2+(seed$y[i]-resp$y)^2}
  dist = sapply(1:15, d.1)
  
  assignment = solve_LSAP(dist)
  best.dist = dist[cbind(seq_along(assignment), assignment)]
  
  return(sqrt(mean(best.dist)))
}

RMSE.to.start = function(t.seed, t.chain, r.seed, r.chain){
return(do.call(rbind, lapply(1:20, function(i){
  targ = subset(dat[,c('x', 'y')], dat$iter==1 & dat$seed==t.seed & dat$chain==t.chain)
  resp = subset(dat[,c('x', 'y')], dat$iter==i & dat$seed==r.seed & dat$chain==r.chain)  
  return(data.frame(targ.seed = t.seed, 
             targ.chain=t.chain, 
             targ.iter=1, 
             resp.seed=r.seed, 
             resp.chain=r.chain, 
             resp.iter=i, 
             RMSE=RMSE.trial(targ, resp)))})))
}

t.seeds = 1:10
t.chains = 1
r.seeds = 1:10
r.chains = 1:10

if(RECALC){
  RMSEs = data.frame()
  for(t.seed in t.seeds){
    for(t.chain in t.chains){
      for(r.seed in r.seeds){
        for(r.chain in r.chains){
          print(c(t.seed, t.chain, r.seed, r.chain))
          RMSEs = rbind(RMSEs, RMSE.to.start(t.seed, t.chain, r.seed, r.chain))
        }
      }
    }
  }
  save(file = 'RMSE.chains.Rdata', list=c('RMSEs', 'dat'))
} else {
  load('RMSE.chains.Rdata')
}

d.iter.match = filter(RMSEs, targ.seed==resp.seed) %>% 
  group_by(resp.iter) %>% 
  summarise(mRMS = mean(log10(RMSE+1)), 
            sRMS = sd(log10(RMSE+1))/sqrt(length(unique(interaction(resp.chain, resp.seed)))),
            nchain = length(unique(interaction(resp.chain, resp.seed)))) %>%
  mutate(match="Correct")
d.iter.nomatch = filter(RMSEs, targ.seed!=resp.seed) %>% 
  group_by(resp.iter) %>% 
  summarise(mRMS = mean(log10(RMSE+1)), 
            sRMS = sd(log10(RMSE+1))/sqrt(length(unique(interaction(resp.chain, resp.seed)))),
            nchain = length(unique(interaction(resp.chain, resp.seed)))) %>%
  mutate(match="Random")
d.iter = rbind(d.iter.match, d.iter.nomatch)

ggplot(filter(d.iter, resp.iter>1), aes(x=resp.iter, y=mRMS, group=match, color=match, ymin=mRMS-sRMS, ymax=mRMS+sRMS))+
  geom_linerange()+
  geom_point()+
  geom_line()+
  labs(x = "Chain iteration", y="Distance to seed: mean(log10(RMSE))")+
  theme_bw()

rel.error = group_by(RMSEs, resp.seed, resp.chain, resp.iter) %>% 
  mutate(t.val = RMSE[(resp.seed == targ.seed)]) %>% 
  summarise(p.bigger = (sum(RMSE>=t.val)-1)/(length(RMSE)-1), n=(length(RMSE)-1)) %>% 
  ungroup() %>% 
  group_by(resp.iter) %>% 
  summarise(big.m=sum(p.bigger*n)/sum(n), big.s=sqrt(sum(p.bigger*n)/sum(n)*(1-sum(p.bigger*n)/sum(n))/sum(n)))


RMSE.n.back = function(t.seed, t.chain, r.seed, r.chain, n, shuffle=FALSE){
  return(do.call(rbind, lapply(1:(20-n), function(i){
    targ = subset(dat[,c('x', 'y')], dat$iter==i & dat$seed==t.seed & dat$chain==t.chain)
    if(shuffle){
      resp = subset(dat[,c('x', 'y')], dat$iter==sample((1:20)[-i], 1) & dat$seed==r.seed & dat$chain==r.chain)  
    } else {
      resp = subset(dat[,c('x', 'y')], dat$iter==i+n & dat$seed==r.seed & dat$chain==r.chain)  
    }
    return(data.frame(targ.seed = t.seed, 
                      targ.chain=t.chain, 
                      targ.iter=i, 
                      resp.seed=r.seed, 
                      resp.chain=r.chain, 
                      resp.iter=i+n,
                      n.back=n,
                      RMSE=RMSE.trial(targ, resp)))})))
}

if(RECALC){
  RMSE.n = data.frame()
  for(t.seed in 1:10){
    for(t.chain in 1:10){
      for(n in 1:15){
        print(c(t.seed, t.chain, n))
        RMSE.n = rbind(RMSE.n, 
                       mutate(RMSE.n.back(t.seed, t.chain, t.seed, t.chain, n), match="Correct"))
      }
    }
  }
  
  for(t.seed in 1:10){
    for(t.chain in 1:10){
      for(n in 1:15){
        print(c(t.seed, t.chain, n))
        r.seed = sample((1:10)[-t.seed],1)
        RMSE.n = rbind(RMSE.n, 
                       mutate(RMSE.n.back(t.seed, t.chain, r.seed, t.chain, n), match="Random seed"))
      }
    }
  }
  
  for(t.seed in 1:10){
    for(t.chain in 1:10){
      for(n in 1:15){
        print(c(t.seed, t.chain, n))
        r.chain = sample((1:10)[-t.chain],1)
        RMSE.n = rbind(RMSE.n, 
                       mutate(RMSE.n.back(t.seed, t.chain, t.seed, r.chain, n), match="Random chain"))
      }
    }
  }
  
  
  for(t.seed in 1:10){
    for(t.chain in 1:10){
      for(n in 1:15){
        print(c(t.seed, t.chain, n))
        RMSE.n = rbind(RMSE.n, 
                       mutate(RMSE.n.back(t.seed, t.chain, t.seed, t.chain, n, shuffle=TRUE), match="Random order"))
      }
    }
  }
  save(file = 'RMSE.nback.Rdata', list=c('RMSE.n', 'dat'))
} else {
  load('RMSE.nback.Rdata')
}

n.back.RMSE = RMSE.n %>% 
  mutate(ch = interaction(targ.seed, targ.chain)) %>%
  group_by(n.back, match) %>% 
  summarise(mRMSE = mean(log10(RMSE)), 
            sRMSE=sd(log10(RMSE))/sqrt(n_distinct(ch)), 
            n=n_distinct(ch)) %>%
  ungroup()

ggplot(n.back.RMSE, aes(x=n.back, y=mRMSE, ymin=mRMSE-sRMSE, ymax=mRMSE+sRMSE, color=match, group=match))+
  geom_linerange()+
  geom_point()+
  geom_line()+
  labs(x = "n back", y="Distance n back: mean(log10(RMSE))")+
  theme_bw()
write.csv(n.back.RMSE,'data/n_back.csv')


