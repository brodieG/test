x <- rep(paste0(readRDS('lorem.cn.RDS'), collapse=''), 1000)

microbenchmark::microbenchmark(
  trunc_speed(x, 512L, TRUE), trunc_speed(x, 512L, FALSE)
)
microbenchmark::microbenchmark(
  trunc_speed(x, 128L, TRUE), trunc_speed(x, 128L, FALSE)
)

system.time()
system.time()

