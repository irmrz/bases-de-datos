ffoldr :: (a -> b -> b) -> b -> [a] -> b 
ffoldr f c [] = c 
ffoldr h c (x:xs) = h x (foldr h c xs)

mymap :: (a -> b) -> [a] -> [b]
mymap f = ffoldr (\x xs -> f x : xs) []
