BEGIN {
serail_new=0
serial_old=0
}
{
if ($1 > 2000010101 && $1 < 2050010101)
{
serial_old=$1
tmp=strftime("%Y%m%d")
serial_new=tmp*100+1
while (serial_old >= serial_new)
{
serial_new++
}
print " "serial_new, " ",$2,$3,$4,$5,$6,$7,$8.$9
}
else{
print $0
}
}
END {
} 
