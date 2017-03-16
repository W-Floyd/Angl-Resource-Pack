#smeltconfig#
echo 'something to use a pipe' | rev > /dev/null
compgen -A variable > /tmp/tmpvars
################################################################
# Start customizing from here
################################################################

__name='Angl'

__sizes='32 64 128 256 512 1024'

__smelt_make_mobile_bin='./convert_to_mobile.sh'

__optimizer='optipng'

__max_optimize='512'

__max_optional='2048'

__should_optimize='1'

################################################################
# Stop customizing from here
################################################################
compgen -A variable > /tmp/tmpvars2
for __variable in $(grep -Fxvf /tmp/tmpvars /tmp/tmpvars2); do
    export "${__variable}"
done
