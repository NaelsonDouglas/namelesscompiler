int shellSort(int nums::, int n) 
{
    int h = 1    
    while(h < n) 
    {
            h = h * 3 + 1
    }    
    h = h / 3
    int c, j
    
    while (h > 0) 
    {
        for (int i = h, i < n, i++)  
        {
            c = nums::i
            j = i
            while (j >= h && nums[j - h] > c) {
                nums::j = nums::(j - h)
                j = j - h
            }
            nums::j = c
        }
        h = h / 2
    }
    return nums}
    