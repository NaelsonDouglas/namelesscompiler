void fibonacci(int n)
{
  if (n<0){return}

  if (n == 0){
    print("0")
    return
  }
  if (n == 1){
    print("0.1")
    return
  }
  if (n>1)
  {
    int sequence::n=1
    sequence::0 =0
    sequence::1 =1
    print(sequence::0)
    print(".")
    print(sequence::1)
    
    int i = 2
    while(i<n){
          sequence::i = sequence::(i - 1) + sequence::(i - 2)
          print(",")
          print(sequence::i)
      i=i+1}}}