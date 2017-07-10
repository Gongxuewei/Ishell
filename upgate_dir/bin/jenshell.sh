LINE="========================================================"
ssh  $1 -l $2 "sh $3 $4 $5 $6 $7"
echo ""
echo $LINE
echo "Application startup is complete"
echo $LINE
echo ""
