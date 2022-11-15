#!/bin/csh
###################################################################################
# システム :NRI
# システム名称: 最初のプログラミング
# 改訂履歴
# 年月日        区分     所属    内容
# 20221026      新規     トゥアン  最初のプログラミング
#
# Copyrigt (C) 2022 by Le Trong Tuan
# All rights reserved
###################################################################################
#----------------------------------------------------------------------------------
# 初期処理
#----------------------------------------------------------------------------------

set rtn            = 0                                        #終了ステータス初期化
set JOBNM          = `basename $0 .csh`                                 #シェル名称
set LOGF           = /home/oracle/NRI/log//${JOBNM}.log               #ログファイル
set JPB_USER_LIST  = "wk_jpb_user.txt"                     #JPBユーザリストファイル
set PROG_ID        = "WGPJ102"                                        #プログラムID
set FILE_ID        = "JPJHBUNP"                                     #出力ファイルID
set FILE_EXT       = "dat"                                    #出力ファイルの拡張子
set OUTFILE_NM     = "AAAAAAAAAAファイル"                           #出力ファイル名

#----------------------------------------------------------------------------------
#タイトル表示
#----------------------------------------------------------------------------------
echo ""                                                                   >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo "※ジョブID： ${JOBNM}"                                              >>& $LOGF
echo "※ジョブ名称：  ${OUTFILE_NM}作成処理"                              >>& $LOGF
echo "※開始       ：`date '+%Y/%m/%d %H:%M:%S'`"                         >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo ""                                                                   >>& $LOGF
#----------------------------------------------------------------------------------
#STEP01: JPBユーザリストファイル存在チェック
#----------------------------------------------------------------------------------
set STEPNM = ${JOBNM}"01"
echo ""                                                                   >>& $LOGF
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Started."                  >>& $LOGF
if(! -e ${APL_D_WORK}/${JPB_USER_LIST}) then
   set rtn = 1
   echo "${APL_D_WORK}/${JPB_USER_LIST}存在しません"                      >>& $LOGF
   echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Abnormally"       >>& $LOGF
   goto END_JOB
endif
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Normally"            >>& $LOGF
#----------------------------------------------------------------------------------
#STEP02: 業務日付取得
#----------------------------------------------------------------------------------
set STEPNM = ${JOBNM}"02"
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Started."                  >>& $LOGF
set email = `sqlplus hr/123456`  <<EOF                                    >>& $LOGF
    WHENEVER SQLERROR EXIT SQL.SQLCODE
         SET VERIFY OFF
         SET TERMOUT OFF
         SET PAGESIZE OFF
         SET ECHO OFF
         SET FEEDBACK OFF
         SET TRIMSPOOL ON
         SELECT
            email
         FROM
            employees
         WHERE
            employee_id = 100;
    EXIT SQL.SQLCODE
EOF
set W_STATUS = $status
if (${W_STATUS}) then
   set rtn = 1
   echo "業務日付取得で、エラーが発生しました。"                          >>& $LOGF
   echo ${W_STATUS}                                                       >>& $LOGF
   echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Abnormally"       >>& $LOGF
   goto END_JOB
endif
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Normally"            >>& $LOGF

END_JOB:
echo ""                                                                   >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo "※終了        ：`date '+%Y/%m/%d %H:%M:%S'`"                        >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo ""                                                                   >>& $LOGF
exit ${rtn}