
# Things to drill down on
1) From 20 -> 21: why can I `echo <stuff> | nc -l -p 60606`? Does it effectively run `nc -l -p 60606 -e "echo <stuff>"`? What else can I pipe to nc? nc also takes a -c/-e flag where it can accept a script or binary to run when connections are made.
2)