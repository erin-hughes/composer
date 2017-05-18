(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Q�Y �]Ys⺶����y�����U]u�	�`c�֭�g&cc~�1��3t҉w�j��A��%�o-eI��>Y�Wn��!�ח )@����$��z��PEhCi��Aq�����_Ӝ��dk;���Z��v��\��)�G�O|?�������4^f�2".�?E�d%�2��oS�_�C��_�-�����叒$]ɿ\(����⊽w4\.��9�%���}��S���p��)�*���k���N�;�����q0Ew�~z-�=�h, (J҅�;_ԞG�����ʽ��/����]��]�<�l�%�b*�(M�Iظ�E����OS$����Q����O�7�W��
�����?E���q}���ӥ������:��Zy�j=]6�!�ڢuʃ���Me�w٤�0	���
V�ׂ���ikA�*̄Բ�O�4q��W��B���f<�-�x�X��I�	ܑ�㹉�S�z�B4�Y��|��,=�N�R7��@��4}������@�e����E/�P׾�N�U����;�7�/�ۋ�K�Oׯ;���0�Z�+�%�������ď����8�T�`�����ϋ�!K2_��[�/�|��y�vC��eMYJ|2�{[f���-�e�6���|��i� f\�hY�%����98��R���甶�I�=o݈L,C*�v��v�:���,���5$g�H�9QW s��D�݆�p��~|w�z\��P��-ƣVύܝ�#H0D\�\9^���H0�"Mޫ����Ď��L�4��x :t�94��:q���[{(���\C0��)�p#ica���1���8?n�.�B~�A�'�xh���Tn�pJ�۟i��B�ӛ�B"N�U1"�6o��b�IdJ؍�i�v�k���2uN�em
h�	���\2T�p;ByWZj�����՝)�̵����y
 ���	����&E��@���~��hp�~|n���L�>�\G�/��:]dL�A����~�bd�T��M�6�7#Q�o�+��P��Hq���@^�N�2�'1�E]��YF�y���g|���v.��r���6��(^������Y�r,�Y��i6�uه�fó��O��r�K�?������?JT�_
>I��ҟ� o�?���1�B*�/o�8+�߉��_j�a�l���j�����y·�܎��a���D����B�~ƨ�'T�CR���8(�X\L$�H+�앙{��H�?�������J�gF�D���d�{'ZL��%p�k�9jXC"ԗ������ۻ|��,�G��c��"�s1����V���( ͽ���K���2��]�թ� �����&́�l���9�zKӔ3#gh�ˋ,�?�|^ o�Jf��rB�=<�!�|-�t��������L^��B>J$��O��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%����`���?IRU�G)������������2P����_���=����1���?�H��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��O������,��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��G�K��+����R�Y�������e�Z�������j��C��+�*�/�$�G��S���}�?�{���
���#��fk�/���0�d��ˇ��F?�586}&�C\��v����@��r���L�1ɤޛJsk:�LІ����CE�ctW$a��:�;^o�a�����5Q�Ǡ)Q/�q1A�:ܠ�ɪc��,�=Ѻ�i[<2.g�cDґ����9��A�6h�p�4�Cr��mEl	`�8�v�vS4���MV&�����-�3�q�|�0�ٓA�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_��_�CT�_>E�_�S�)��������?�x��w�v9��V�)�D�o��������_�����+��������!����I�U\���p	�{�M:x�������Юoh�a8�zn�<ΰJ",�8, �Ϣ4K��]E��~(C����!4�V�_� �Oe®ȯV+U���؜����=�i�m����?��)���H�	�S����;����^����=��n�c�Vi�ہ�8"��	�y� ���`�ʇ7y��)%�v�Y��a<��q�������D��_�!��<��?Tu�w9�P���/S
��'�j������A��˗����q��_>S�/m�X�8�����R�;��`8�|�']����/��,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#�������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��>�Ϝ�/m���GЕ�W
~�%�������W�h�?Ⱦ4Z�B�(C�o�(A>��&����+o����_����΁X�qе
�%,�!?;�y<���%�������a�Ui��U��n�/���CwA�����h�� 菞=hZ�a��-
'���N����B�N{Ġ�7��j�66a�'�E�\�n�Y=�c�1<�j2�:�޼9��\�t���[q�\R|o6h&*�n�Q�z���b��G�y��p���s��i�X�s�%_���ԕsY�Hњ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>��nk�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i��Ń}��i;������R�[��^����f��$�r~K�!�7��g�?	���/���ѿ��1nۯ�x7w��i*�;<��}���{C��<3���#� ����} �'�@���-��) ��i����1^9zp Dbl'�����>���$���ld�l�k��e+=5%���ʱkiBÐNe3&ɜ��ep*7<��k����q�W��[�A@O�x�ygs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>S��t���?BSU�_)�-��Y�G���$|�����=(C�Y�?~�ge�=���j��Z����ߩ�?t
���?�a��?�����uw1�cBW񟥠����+��s���X�����?�����������1%Q�q(�%\���"��� p���G	�X�
p�G(��������
e����g�PH��S
.����)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����UQRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��?J�̿�G�Ͽ�������/�U��U
�~�Z�[�o�o��t;u��T��6r��j���o��>�Ӆ��tl'��W��m�P7q�^#�ȕ�H&��3�r;M�e�/��Jj���8]�oxp��*�w�_��Ok�:��OOL�t����?4Bߎ��sJ+nd/�o�lR�rk?��v�vU�\W+��¯�y�'��X�8W4�����	'�ծ��i�ŷ��$��v坺`/6������KNu��ާ����ڞ.��fiGŨp훻ʠ����p;r���}cX��hluuA�E��!��:7�o�*]���#ק/�>^�r_�fW�~��[E%��|��^�q������\;�BϾ��.:J�'߻�o�,-���DYrg��X����}�u��Y�E���K�2iA���^ܛ������j]���+��o�֦w�����������?�g�䏯�@.*�=,�����q:�.�o�~��q���8��8K]8��'�PY?�n��v��&>ф�D����8���S�n�>*��~~ˇ#������NYo�c������	d��
�8��!�"v�w�h�<.��#��:����M��3B�+����r����$����N�t��ϖ�u�p��>��q����6�u�L������v��v��!�����:���(u�8�8N�|'Ku��8v'�����
H�H��E��@��?*@�_�����E���u�в[��8vO2If2��m)>W��������>����M���/�b�ٜu0����-����y�8�g�t�N�2d>��v�+��ҹ\"s+��%�$��u혁��IB���2�M�I��ʹ�e �Z����ż&�y	xs[�sB	��0-䝮�,�ꪢ�.C�v���kb�����C�0\j��d@ðK� kquĮ	3.ްD,<�e�nW3�nBm4���	8S�f�գK�IS��x:�����|)�eXh9�ߪ�u��t_!�-�y���3�<ssZ��Cs���آJ��y_����>�hį>O���j�4e�:j�&vj�-��7g{QS4�֣)��F�U�E�u�6��Y�tm&N8=�����[�S�+��ى�����j|�]]���75�I����V������<n���uNitZs��sRK�a렛J���	�U|�����O�G.��eG̞���"l�_��2�2ѹ�+��7����?�����74�
S0~�e.����áh9_
NK�c˗!Ly%g�?fJA=l��3@���M(r�Z�lU�4E��F7߰n �x�������df/G��?�v����t�l��k�;�b�߹W����sO-59|�V����ǒ��DĔ����ou:�A�.3&h�ޖ�,c<�M��AO4��lr����j�3�}��k��+�kUQ�ov�va��u�9�uW��-�bVՀ~:����f�QD��
��p>��A���u��V������?��pk�?��ϫ��/��iPں�si�����r�c�č'���7��y�!��}?��"�����x�o?P�{�@j�Ob�O���'".p��ޑ�o��Е���S�s�v���?�Կ�z��?����3�ҝ�1�w���i ����� �ő���5�&���k��!���p�+O 5�sS��tS���+-��7o0��y`B�#qYH�ya�66���I��9i�\�,��A�<�����ma�7���a�B�' ��p�@�w#�>�M��^�7�-�qj���^!X��{��1'��\��1UuPh��0,��>hFY�Xq"�,6ó��m�`ɊI�H��lC�p%JSE����aT`�������q�e�lx�#\b�U�0O΄Wɂcv{k��H.��\k7S�<tJ�T}�f�8`�d�R��W3����Ҿ�G�i�R�^E�U��1��3zFC�~�a��V�#�!_��0a&�Ä݄	�|�D�ݏ����ѹM=!�ڛz�S�k~~K�)����FȺW�(%��x���c^2��$ӡ\Z��R����L���Hb����sa�P�q��k�=��\�η��bJ��Q�CV���,��fP���A*ҍ�x��S��^��+XBV��E�>�����ë���j2F3�X�'��lDI��8-+�z�����z��
7��T�D�%%��Ho3\��m4_}e�����ـuAY����BDKt��:���(�M�4��V�(��N<Z���>�u��H1J�3�̈́KIF��N ��ڨ���锅��h�&�FK�:`X�pE2�Q2K�rDxAv���u	��x60�)�/&�N�WC� PO/W�h���$f)�h\/�q����Τc� Vhs��TO{��<�EJ���$V)�p���W�����c0r�&q��y �y�ᩱ7-��F��_"�hPˊb�,�"�GI-^V�
�ԸV��ɖp�{�XBi�)����S���n(�Q���z����?�e<�\U�%e9"� �VY��.�q���!+Ut	e�<;(-����?�����ݖ����h�B�R�_��˱|Z�1l�����^�;NY܎���l�϶�϶s�4~�w��FW��]ȵ�;�d��^غc�
���Wi;�L���ʾ}.�6re>����UeE�v��v��滂l���^�����{چ-��B��9(�*a�<���#AԺ��LN�<�&1��ht���U�@�檺��gĎ�3�#MD��Kࢡ*�-��X��5�"����~�ocW�y�eߦ�ȕ�7!`�{��-s�6)�E^iԬ�#oE���؏c�<��l��y��S\W����2�i�/&>�9bV�H?�Sd�AVu�㙁��� ���H�����1�����!�y��6��m���s^
����_
�;q�,<��d;4�5s�>Q
S�b'�������}�A[)����\t0��֢��b�a_l��`�Ȃ�3G�u��Y���i�7k� �yp�{X0�����},C��1����eگ���F�x%�ǹP4V�3R����$�x��a�9т_J��~���U�x:��&�6�J�Y�k,�T92��Z�̀�b���#d,,e�cr�4f�C��5d���P�h"�PB���������{��Ԙ`�F��Z�GЁ�X,��Z2����U�����<�f������pd��^H2������`zá��C�����h^mp\j�A6!����1�8�8���zI� o�N�[��˦?4uL�s�|�s`�g�(�|p.ý�e;á�;�'zX���?1;Ʒ�������xXN$�I�t��G�V%ZKc��i.�$���XR ��78r8X,��h-*7Il!�"��8kPd�*0	��7kβ���ab���`1��m-E�� )G�2
����C�;��E���3r1^�0��U�O����x}=RU���h4��l%�`LB��K�����p�`�a,�*���(���!�|�-v����+`qO���b����K;� C���Ƥ S��J�F�E5\��c4ϥ0f��Q"lmO-���qCN�)$Z� |��E�ڬb�^?Mz�
-�����c�q��ǩ��b�o#��{j�l!����Br��vn���]���qސ)��{B��[�­��tߜ��4�I�j�h�{�>p�����������[���l�K�8���; �Q�<�G5���E�r����6�����{��=�~���g_��s�����������s?����ך��Ŵr��9�q"��]�#�w���%���_��o=��_���o�������L>��g��>������\���{|)	��A��֝&�o���^��d:Q��� W��Н�{��m���v��8�/������o����A~=G���yy���K���P;j�Cph�����z�������C�t���������@�<5��6�Ao��T�	4�Rf�a���ۢ��m!t�����o=gb謏��<B���u�9j���3p�:�g�|Ju>�:<�8�x�xg�H��5p;������4�u��3gƉ�:sf�iδ gΌc�q܆93g��{�)0�cf΍�Ý"��)m��%��#����vm�;&���$'9�I���WLu�  