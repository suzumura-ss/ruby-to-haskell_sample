module Factorial where
import Foreign.C.Types

foreign export ccall factorial :: CULong -> CULong
factorial 0 = 1
factorial x = x * factorial(x-1)
