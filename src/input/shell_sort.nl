int shellSort(int nums, int n) 
{
    int h = 1    
    while(h < n) 
    {
            h = h * 3 + 1
    }    
    h = h / 3
    int c=-1
    int j=-1
    
    while (h > 0)
    {
        for (int i = h, i < n, i=i+1)  
        {
            c = nums::i
            j = i            
            while(j >= h) {
                while( nums(j-h)>c){
                        nums::j = nums::(j-h)
                        j = j - h
                    }
            }
            nums::j = c
        }
        h = h / 2
    }
    return nums}
    