void fibonacci(int n)
{
  if (n<0){return -1}

  if (n == 0){
    print("0")
    return -1
  }
  if (n == 1){
    print("0.1")
    return -1
  }
  if (n>1)
  {
    int sequence::n=1
    sequence::0 =0
    sequence::1 =1
    seq = sequence::0
    print(seq)
    print(".")
    seq = sequence::1
    print(seq)
    
    int i = 2
    while(i<n){
          m1 = (i - 1)
          m2 = (i - 2)
          sequence::i = sequence::m1 + sequence::m2
          print(".")
          out = sequence::i
          print(out)
      i=i+1}}}