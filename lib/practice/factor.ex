# This algorithm was taken from this site: 
# https://people.revoledu.com/kardi/tutorial/BasicMath/Prime/Algorithm-PrimeFactor.html
defmodule Practice.Factor do
    def doFactor(x, i, primes) when x < i*i do
      primes ++ [x]
    end
    def doFactor(x, i, primes) do 
      if rem(x,i) == 0 do
        doFactor(round(x/i), i, primes ++ [i])
      else
        doFactor(x, i + 1, primes)
      end
    end
    def factor(x) do
      primes = []
      i = 2
      doFactor(x, i, primes)
    end
  end
  