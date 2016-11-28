library(clue)
library(dplyr)
library(magrittr)
library(ggplot2)
library(spatstat)

setwd('/Users/timlew/Documents/github_private/iterated_learning_analyses')

dat = read.csv2('data/dots_memory.csv', sep=',')

dat$x = as.numeric(as.character(dat$x))
dat$y = as.numeric(as.character(dat$y))

r = 265
r.null = 0.5*sqrt(pi*r^2/15)
th = rev(seq(0, 2*pi, pi/50))
circle = data.frame(x=r*sin(th), y=r*cos(th))

W = owin(xrange=c(-r,r), yrange=c(-r,r), poly = circle)

Lsum = function(x,y){
  L.df <- as.data.frame(Lest(as.ppp(cbind(x,y), W=W)))
  tmp = log10(L.df$iso/L.df$r)
  tmp <- tmp[L.df$r>20 & !is.na(tmp) & !is.infinite(tmp)]
  return(mean(tmp, na.rm=T))
}

NN.ratio = function(x,y){
  r.obs = mean(nndist(as.ppp(cbind(x,y), W=W)))
  return(log10(r.obs/r.null))
}

Lsum.out = dat %>% group_by(Seed, Chain, Iter) %>% summarise(Lsum = Lsum(x,y))
save(file = 'Lmean.Rdata', list=c('Lsum.out'))
nnratios = dat %>% group_by(Seed, Chain, Iter) %>% summarise(nnratio = NN.ratio(x,y))

L.iter = Lsum.out %>% 
  group_by(Iter) %>% 
  summarise(m = mean(Lsum), s = sd(Lsum), n=length(Lsum)) %>%
  ungroup()

ggplot(L.iter, aes(x=Iter, y=m, ymin=m-s/sqrt(10), ymax=m+s/sqrt(10)))+
  geom_linerange()+
  geom_point()+
  geom_line()+
  theme_bw()

NN.iter = nnratios %>% 
  group_by(Iter) %>% 
  summarise(m = mean(nnratio), s = sd(nnratio), n=length(nnratio)) %>%
  ungroup()

ggplot(NN.iter, aes(x=Iter, y=m, ymin=m-s/sqrt(10), ymax=m+s/sqrt(10)))+
  geom_linerange()+
  geom_point()+
  geom_line()+
  labs(x="Chain position", y="Nearest neighbor ratio") +
  theme_bw()

write.csv(NN.iter,'data/NN_iter.csv')
