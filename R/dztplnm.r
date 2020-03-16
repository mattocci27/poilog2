#' The zero-truncated compund poisson-lognormal distributions mixture
#'
#' Density function and random generation for Zero-Truncated 
#' Poisson Lognormal distribution with parameters `mu`, `sig`, and `theta`.
#'
#' Type 1 ZTPLN truncates zero based on Poisson-lognormal distribution and 
#' type 2 ZTPLN truncates zero based on zero-truncated Poisson distribution.
#' For mathematical details, please see `vignette("ztpln")`
#'
#' @param n number of random values to return.
#' @param mu vector of mean of lognormal distribution in sample 1.
#' @param sig vector mean of lognormal distribution in sample 1.
#' @param theta vector of mixture weights
#' @param x	vector of (non-negative integer) quantiles.
#' @param log logical; if TRUE, probabilities p are given as log(p).
#' @param type1 logical; if TRUE, Use type 1 ztpln else use type 2.  
#' @return dpois gives the (log) density, ppois gives the (log) distribution
#' function, qpois gives the quantile function, and rpois generates random
#' deviates.
#' @seealso \code{\link{dztpln}}
#' @examples
#' rztplnm(n = 100, mu = c(0, 5), sig = c(1, 2), theta = c(0.2, 0.8))
#' dztplnm(x = 1:100, mu = c(0, 5), sig = c(1, 2), theta = c(0.2, 0.8))
#' dztplnm(x = 1:100, mu = c(0, 5), sig = c(1, 2), theta = c(0.2, 0.8), type1 = TRUE)
#' @export
dztplnm <- function(x, mu, sig, theta, log = FALSE, type1 = FALSE) {
  if (length(mu) != length(sig) |
      length(mu) != length(theta) |
      length(sig) != length(theta)) {
    stop("The length of vectors of mean, 
         variance and mixture weight need to be same.")
  }
  if (sum(theta) != 1) warning("Sum of the mixture weight should be 1.")
  theta <- theta / sum(theta)
  if (type1) {
    lik <- do_dztplnm(x, mu, sig, theta)
  } else lik <- do_dztplnm2(x, mu, sig, theta)
  if (log) return(log(lik)) else return(lik)
}

#' @rdname dztplnm
#' @export
rztplnm <- function(n, mu, sig, theta, type1 = FALSE) {
  # theta: mixture weight for the first compoment
  if (length(mu) != length(sig) | length(mu) != length(theta) |
      length(sig) != length(theta)) {
    stop("The length of vectors of mean, 
         variance and mixture weight need to be same.")
  }
  if (sum(theta) != 1) warning("Sum of the mixture weight should be 1.")
  if (type1) stop("type 1 ztpln random sampling is not implemented. 
                  Please use type1 = FALSE")
  z <- rmultinom(n, 1, theta)
  z2 <- as.numeric(z * seq(1, length(mu)))
  z3 <- z2[z2 > 0]
  x <- do_vec2_rztpln(n, mu[z3], sig[z3])
  return(x)
}
