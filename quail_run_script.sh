cd /home/icare/quailroot
echo $(whoami) $(pwd)

if [ ! -d "/home/icare/quailroot/sources/icare" ]; then
    printf "No %s project defined, building the project from environment variables." icare | echo
    echo "This is stored in a volume on the machine! Remember to clean up!"
    quail redcap generate quail.conf.yaml icare $TOKEN $REDCAP_URL
    echo "Done adding the quail redcap source"
fi

# Download the data
echo "getting redcap metadata"
quail redcap get_meta icare
echo "getting redcap data"
quail redcap get_data icare
echo "generating the redcap metadata database"
quail redcap gen_meta icare
echo "generating the redcap data database"
quail redcap gen_data icare