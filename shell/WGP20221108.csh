#!/bin/csh
###################################################################################
# �V�X�e�� :NRI
# �V�X�e������: �ŏ��̃v���O���~���O
# ��������
# �N����        �敪     ����    ���e
# 20221026      �V�K     �g�D�A��  �ŏ��̃v���O���~���O
#
# Copyrigt (C) 2022 by Le Trong Tuan
# All rights reserved
###################################################################################
#----------------------------------------------------------------------------------
# ��������
#----------------------------------------------------------------------------------

set rtn            = 0                                        #�I���X�e�[�^�X������
set JOBNM          = `basename $0 .csh`                                 #�V�F������
set LOGF           = /home/oracle/NRI/log//${JOBNM}.log               #���O�t�@�C��
set JPB_USER_LIST  = "wk_jpb_user.txt"                     #JPB���[�U���X�g�t�@�C��
set PROG_ID        = "WGPJ102"                                        #�v���O����ID
set FILE_ID        = "JPJHBUNP"                                     #�o�̓t�@�C��ID
set FILE_EXT       = "dat"                                    #�o�̓t�@�C���̊g���q
set OUTFILE_NM     = "AAAAAAAAAA�t�@�C��"                           #�o�̓t�@�C����

#----------------------------------------------------------------------------------
#�^�C�g���\��
#----------------------------------------------------------------------------------
echo ""                                                                   >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo "���W���uID�F ${JOBNM}"                                              >>& $LOGF
echo "���W���u���́F  ${OUTFILE_NM}�쐬����"                              >>& $LOGF
echo "���J�n       �F`date '+%Y/%m/%d %H:%M:%S'`"                         >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo ""                                                                   >>& $LOGF
#----------------------------------------------------------------------------------
#STEP01: JPB���[�U���X�g�t�@�C�����݃`�F�b�N
#----------------------------------------------------------------------------------
set STEPNM = ${JOBNM}"01"
echo ""                                                                   >>& $LOGF
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Started."                  >>& $LOGF
if(! -e ${APL_D_WORK}/${JPB_USER_LIST}) then
   set rtn = 1
   echo "${APL_D_WORK}/${JPB_USER_LIST}���݂��܂���"                      >>& $LOGF
   echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Abnormally"       >>& $LOGF
   goto END_JOB
endif
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Normally"            >>& $LOGF
#----------------------------------------------------------------------------------
#STEP02: �Ɩ����t�擾
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
   echo "�Ɩ����t�擾�ŁA�G���[���������܂����B"                          >>& $LOGF
   echo ${W_STATUS}                                                       >>& $LOGF
   echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Abnormally"       >>& $LOGF
   goto END_JOB
endif
echo "`date +'%Y/%m/%d %H:%M:%S'` ${STEPNM} is Ended Normally"            >>& $LOGF

END_JOB:
echo ""                                                                   >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo "���I��        �F`date '+%Y/%m/%d %H:%M:%S'`"                        >>& $LOGF
echo "#------------------------------------------------------------------">>& $LOGF
echo ""                                                                   >>& $LOGF
exit ${rtn}