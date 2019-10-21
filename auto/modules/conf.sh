
# Copyright (C) kenblikylee
# Copyright (C) kenblog.top


shift

case "$module" in

   python)
       . auto/modules/python.sh
   ;;

   nodejs)
       . auto/modules/nodejs.sh
   ;;

   *)
       echo
       echo $0: error: invalid module \"$module\".
       echo
       exit 1
   ;;

esac
