void fibonacci(int n)
{
  if (n<0){return}

  if (n == 0){
    print("0")
    return
  }

  if (n == 1){
    print("0,1")
    return
  }

  if (n>1)
  {
    int sequence::n
    sequence::0 = 0
    sequence::1 = 1
    print(sequence::0)
    print(",")
    print(sequence::1)
    
    int i = 2
    while(i<n){
          prev = i-1
          anteprev = i-2
          sequence::i = sequence::(prev) + sequence::(anteprev)
          print(",")
          print(sequence::i)
      i = i + 1
    }
  }
 }