x <- rep(paste0(readRDS('lorem.cn.RDS'), collapse=''), 1000)

system.time(trunc_speed(x, 128L, TRUE))
system.time(trunc_speed(x, 128L, FALSE))

