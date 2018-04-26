cd /home/hcvprod/quailroot
echo $(whoami) $(pwd)

if [ ! -d "/home/hcvprod/quailroot/sources/hcvprod" ]; then
    printf "No %s project defined, building the project from environment variables." hcvprod | echo
    echo "This is stored in a volume on the machine! Remember to clean up!"
    quail redcap generate quail.conf.yaml hcvprod $TOKEN $REDCAP_URL
    echo "Done adding the quail redcap source"
fi

# Download the data
echo "getting redcap metadata"
quail redcap get_meta hcvprod
echo "getting redcap data"
quail redcap get_data hcvprod
echo "generating the redcap metadata database"
quail redcap gen_meta hcvprod
echo "generating the redcap data database"
quail redcap gen_data hcvprod