offset :: Int -> [a] -> [a]
offset 0 _ = _
offset n [] = []
offset n (x:xs) = offset (n-1) xs
