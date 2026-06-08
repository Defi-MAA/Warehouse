-- =====================================================
-- MySQL 转换脚本 - 原 Warehouse 数据库
-- 从 SQL Server 转换为 MySQL
-- 字符集: utf8mb4
-- 存储引擎: InnoDB
-- 所有 CHAR 类型已替换为 VARCHAR
-- =====================================================

-- 删除数据库（如果存在）
DROP DATABASE IF EXISTS Warehouse;

-- 创建数据库
CREATE DATABASE Warehouse
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE Warehouse;

-- =====================================================
-- 表结构定义
-- =====================================================

-- 表: usrdefin
DROP TABLE IF EXISTS usrdefin;
CREATE TABLE usrdefin (
    emField VARCHAR(30) NOT NULL,
    emTitle VARCHAR(30) NULL,
    emflag VARCHAR(1) NULL,
    emMemo VARCHAR(30) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (emField)
) ENGINE=InnoDB;

-- 表: usr
DROP TABLE IF EXISTS usr;
CREATE TABLE usr (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    pswd VARCHAR(8) NULL,
    auth LONGTEXT NULL,
    dept VARCHAR(20) NULL,
    duty VARCHAR(20) NULL,
    memo VARCHAR(80) NULL,
    flag VARCHAR(1) NULL,
    rptauth LONGTEXT NULL,
    wrhsauth LONGTEXT NULL,
    vwsauth LONGTEXT NULL,
    adtauth LONGTEXT NULL,
    wrhsfilter LONGTEXT NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: update627log
DROP TABLE IF EXISTS update627log;
CREATE TABLE update627log (
    logid INT NOT NULL AUTO_INCREMENT,
    syscode VARCHAR(8) NULL,
    tname VARCHAR(30) NULL,
    status VARCHAR(1) NULL,
    message VARCHAR(255) NULL,
    trndate DATETIME NULL,
    trnpsn VARCHAR(50) NULL,
    PRIMARY KEY (logid)
) ENGINE=InnoDB;

-- 表: update627i
DROP TABLE IF EXISTS update627i;
CREATE TABLE update627i (
    upline INT NOT NULL AUTO_INCREMENT,
    upid INT NULL,
    cid INT NULL,
    v6cnam VARCHAR(30) NULL,
    v6chdr VARCHAR(100) NULL,
    v6ctype VARCHAR(20) NULL,
    v6cprec INT NULL,
    v6cscale INT NULL,
    v6ccmnt VARCHAR(150) NULL,
    v7cnam VARCHAR(30) NULL,
    v7ctype VARCHAR(20) NULL,
    v7cprec INT NULL,
    v7cscale INT NULL,
    v7ccmnt VARCHAR(150) NULL,
    sqlclause VARCHAR(255) NULL,
    upflag VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (upline)
) ENGINE=InnoDB;

-- 表: update627
DROP TABLE IF EXISTS update627;
CREATE TABLE update627 (
    upid INT NOT NULL AUTO_INCREMENT,
    syscode VARCHAR(8) NULL,
    tid INT NULL,
    v6tnam VARCHAR(30) NULL,
    v6tcmnt VARCHAR(100) NULL,
    v6townr VARCHAR(20) NULL,
    v7tnam VARCHAR(30) NULL,
    v7townr VARCHAR(20) NULL,
    pktype VARCHAR(1) NULL,
    upflag VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (upid)
) ENGINE=InnoDB;

-- 表: uObject
DROP TABLE IF EXISTS uObject;
CREATE TABLE uObject (
    ObjID INT NOT NULL,
    ObjParentID INT NULL,
    ObjName VARCHAR(30) NULL,
    Title VARCHAR(30) NOT NULL,
    ObjIconID INT NOT NULL DEFAULT -1,
    ObjType INT NOT NULL DEFAULT 1,
    Remarks VARCHAR(60) NULL,
    PRIMARY KEY (ObjID),
    CONSTRAINT ckc_objtype_uobject CHECK (ObjType >= 1 AND ObjType <= 2)
) ENGINE=InnoDB;

-- 表: uGroup
DROP TABLE IF EXISTS uGroup;
CREATE TABLE uGroup (
    GroupID INT NOT NULL AUTO_INCREMENT,
    GroupParentID INT NULL,
    GroupName VARCHAR(30) NOT NULL,
    EName VARCHAR(30) NULL,
    Remarks VARCHAR(60) NULL,
    PRIMARY KEY (GroupID),
    FOREIGN KEY (GroupParentID) REFERENCES uGroup (GroupID)
) ENGINE=InnoDB;

-- 表: wsTPL
DROP TABLE IF EXISTS wsTPL;
CREATE TABLE wsTPL (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(60) NULL,
    datawindow VARCHAR(50) NULL,
    connparm VARCHAR(512) NULL,
    srcpath VARCHAR(100) NULL,
    savepath VARCHAR(100) NULL,
    fnrule VARCHAR(100) NULL,
    vchprd INT NULL,
    vchclas VARCHAR(4) NULL,
    vchpar VARCHAR(100) NULL,
    class VARCHAR(8) NULL,
    ownsys VARCHAR(8) NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    unflag VARCHAR(1) NULL,
    transmitpar VARCHAR(1) NULL,
    SortBy VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: wsFILE
DROP TABLE IF EXISTS wsFILE;
CREATE TABLE wsFILE (
    code VARCHAR(8) NOT NULL,
    wstpl VARCHAR(8) NULL,
    fname VARCHAR(200) NULL,
    fdate DATETIME NULL,
    fpsn VARCHAR(20) NULL,
    edit VARCHAR(1) NULL,
    edtdate DATETIME NULL,
    edtpsn VARCHAR(20) NULL,
    audit VARCHAR(1) NULL,
    adtdate DATETIME NULL,
    adtpsn VARCHAR(20) NULL,
    vch VARCHAR(1) NULL,
    vchdate DATETIME NULL,
    vchpsn VARCHAR(20) NULL,
    ownsys VARCHAR(8) NULL,
    vchtimes INT NULL,
    memo VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: WParts
DROP TABLE IF EXISTS WParts;
CREATE TABLE WParts (
    WOno VARCHAR(8) NOT NULL,
    PartNo VARCHAR(20) NOT NULL,
    Price DECIMAL(16,2) NULL,
    Quantity DECIMAL(8,2) NULL,
    Amount DECIMAL(16,2) NULL,
    Notes VARCHAR(80) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (WOno, Sno)
) ENGINE=InnoDB;

-- 表: WOrders
DROP TABLE IF EXISTS WOrders;
CREATE TABLE WOrders (
    WOno VARCHAR(8) NOT NULL,
    WOtype VARCHAR(8) NULL,
    WOdate DATETIME NULL,
    Department VARCHAR(8) NULL,
    ReqBy VARCHAR(8) NULL,
    EquipNo VARCHAR(20) NULL,
    Location VARCHAR(8) NULL,
    Descript VARCHAR(255) NULL,
    Levels VARCHAR(8) NULL,
    Priority DECIMAL(8,2) NULL,
    SentBy VARCHAR(100) NULL,
    SentDate DATETIME NULL,
    StartDate DATETIME NULL,
    FinishDate DATETIME NULL,
    DownTime DECIMAL(8,2) NULL,
    ManHours DECIMAL(8,2) NULL,
    HoursFee DECIMAL(16,2) NULL,
    PartsFee DECIMAL(16,2) NULL,
    Overhead DECIMAL(16,2) NULL,
    CheckNotes VARCHAR(40) NULL,
    CheckBy VARCHAR(8) NULL,
    CheckDate DATETIME NULL,
    Notes VARCHAR(80) NULL,
    Status VARCHAR(8) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (WOno)
) ENGINE=InnoDB;

-- 表: WOItem
DROP TABLE IF EXISTS WOItem;
CREATE TABLE WOItem (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: WLabors
DROP TABLE IF EXISTS WLabors;
CREATE TABLE WLabors (
    WOno VARCHAR(20) NOT NULL,
    ItemNo VARCHAR(8) NOT NULL,
    ItemName VARCHAR(30) NULL,
    Descript VARCHAR(40) NULL,
    Craft VARCHAR(8) NULL,
    Crew VARCHAR(8) NULL,
    Empl VARCHAR(8) NULL,
    StartDate DATETIME NULL,
    FinishDate DATETIME NULL,
    DownTime DECIMAL(8,2) NULL,
    ManHours DECIMAL(8,2) NULL,
    HoursFee DECIMAL(16,2) NULL,
    Notes VARCHAR(40) NULL,
    Status VARCHAR(8) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (WOno, Sno)
) ENGINE=InnoDB;

-- 表: WageItem
DROP TABLE IF EXISTS WageItem;
CREATE TABLE WageItem (
    RecNo INT NOT NULL AUTO_INCREMENT,
    ItemNo INT NOT NULL,
    ItemOrder INT NOT NULL,
    ItemName VARCHAR(24) NULL,
    ColumnName VARCHAR(24) NOT NULL,
    Formula VARCHAR(200) NULL,
    ItemMemo VARCHAR(40) NULL,
    ItemVisible TINYINT(1) NOT NULL DEFAULT 1,
    ItemFlag VARCHAR(3) NOT NULL DEFAULT 'TMP',
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: wagecoll
DROP TABLE IF EXISTS wagecoll;
CREATE TABLE wagecoll (
    wageappt VARCHAR(8) NOT NULL,
    wagedept VARCHAR(12) NOT NULL,
    accattr VARCHAR(8) NOT NULL,
    d_a_no VARCHAR(16) NULL,
    d_cust1 VARCHAR(16) NULL,
    d_cust2 VARCHAR(16) NULL,
    d_cust3 VARCHAR(16) NULL,
    d_cust4 VARCHAR(16) NULL,
    d_cust5 VARCHAR(16) NULL,
    d_cust6 VARCHAR(16) NULL,
    d_cust7 VARCHAR(16) NULL,
    d_cust8 VARCHAR(16) NULL,
    d_cust9 VARCHAR(16) NULL,
    c_a_no VARCHAR(16) NULL,
    c_cust1 VARCHAR(16) NULL,
    c_cust2 VARCHAR(16) NULL,
    c_cust3 VARCHAR(16) NULL,
    c_cust4 VARCHAR(16) NULL,
    c_cust5 VARCHAR(16) NULL,
    c_cust6 VARCHAR(16) NULL,
    c_cust7 VARCHAR(16) NULL,
    c_cust8 VARCHAR(16) NULL,
    c_cust9 VARCHAR(16) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (wageappt, wagedept, accattr)
) ENGINE=InnoDB;

-- 表: wageappt
DROP TABLE IF EXISTS wageappt;
CREATE TABLE wageappt (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    wageitem INT NULL,
    rate DECIMAL(8,4) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Wage
DROP TABLE IF EXISTS Wage;
CREATE TABLE Wage (
    emID INT NOT NULL,
    wgOrignal DECIMAL(19,4) NOT NULL,
    wgCurrent DECIMAL(19,4) NOT NULL,
    wgCheckTime DATETIME NULL,
    wgClass INT NULL,
    wgMoney DECIMAL(19,4) NULL,
    wgBeginTime DATETIME NULL,
    wgBase VARCHAR(32) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: vws
DROP TABLE IF EXISTS vws;
CREATE TABLE vws (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    datawindow VARCHAR(250) NULL,
    menuitem VARCHAR(250) NULL,
    category VARCHAR(8) NULL,
    remarks VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    whereclause VARCHAR(255) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 索引: vws_category
CREATE INDEX vws_category ON vws (category);

-- 表: vocation
DROP TABLE IF EXISTS vocation;
CREATE TABLE vocation (
    emID INT NOT NULL,
    vctype VARCHAR(24) NOT NULL,
    vcBegdate DATETIME NULL,
    vcEnddate DATETIME NULL,
    vcMemo VARCHAR(32) NULL,
    recNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (recNo)
) ENGINE=InnoDB;

-- 表: rpt
DROP TABLE IF EXISTS rpt;
CREATE TABLE rpt (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(40) NULL,
    datawindow VARCHAR(250) NULL,
    notes VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    ename VARCHAR(40) NULL,
    category VARCHAR(8) NULL,
    remarks VARCHAR(250) NULL,
    SuitList VARCHAR(255) NULL,
    parameters VARCHAR(255) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Rewards
DROP TABLE IF EXISTS Rewards;
CREATE TABLE Rewards (
    emID INT NOT NULL,
    rpType VARCHAR(24) NOT NULL,
    rpTime DATETIME NOT NULL,
    rpReason VARCHAR(255) NULL,
    rpCompany VARCHAR(32) NULL,
    rpEndDate DATETIME NULL,
    rpEndReason VARCHAR(32) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: Resume
DROP TABLE IF EXISTS Resume;
CREATE TABLE Resume (
    emID INT NOT NULL,
    reBegin DATETIME NOT NULL,
    reEnd DATETIME NOT NULL,
    reCompany VARCHAR(255) NULL,
    reWork VARCHAR(24) NULL,
    rePosition VARCHAR(24) NULL,
    reCertifier VARCHAR(12) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: rctype
DROP TABLE IF EXISTS rctype;
CREATE TABLE rctype (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    chktype VARCHAR(1) NULL,
    cobject VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: rcstdcost
DROP TABLE IF EXISTS rcstdcost;
CREATE TABLE rcstdcost (
    tcode INT NOT NULL AUTO_INCREMENT,
    tdate DATETIME NULL,
    tterm VARCHAR(8) NULL,
    chktype VARCHAR(1) NULL,
    rcarea VARCHAR(8) NULL,
    rmno VARCHAR(8) NULL,
    rcitem VARCHAR(8) NULL,
    qty DECIMAL(13,4) NULL,
    qty0 DECIMAL(13,4) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (tcode)
) ENGINE=InnoDB;

-- 唯一索引
CREATE UNIQUE INDEX index_rcstdcost_pkey ON rcstdcost (tdate, tterm, rcarea, rmno, rcitem);

-- 表: rcrmtrans
DROP TABLE IF EXISTS rcrmtrans;
CREATE TABLE rcrmtrans (
    tdate DATETIME NOT NULL,
    tterm VARCHAR(8) NULL,
    rcarea VARCHAR(8) NULL,
    rmno VARCHAR(8) NOT NULL,
    rmtype VARCHAR(8) NULL,
    rmnights DECIMAL(10,2) NULL,
    rmnights0 DECIMAL(10,2) NULL,
    rmcharge DECIMAL(12,2) NULL,
    rmcharge0 DECIMAL(12,2) NULL,
    persons SMALLINT NULL,
    persons0 SMALLINT NULL,
    modified VARCHAR(1) NULL,
    moddate DATETIME NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (tdate, rmno)
) ENGINE=InnoDB;

-- 表: rcitem
DROP TABLE IF EXISTS rcitem;
CREATE TABLE rcitem (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    rctype VARCHAR(8) NULL,
    fritem VARCHAR(8) NULL,
    ivitem VARCHAR(16) NULL,
    unit VARCHAR(20) NULL,
    price DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: rcfctcost
DROP TABLE IF EXISTS rcfctcost;
CREATE TABLE rcfctcost (
    tcode INT NOT NULL AUTO_INCREMENT,
    tdate DATETIME NULL,
    tterm VARCHAR(8) NULL,
    chktype VARCHAR(1) NULL,
    rcarea VARCHAR(8) NULL,
    rmno VARCHAR(8) NULL,
    rcitem VARCHAR(8) NULL,
    qty DECIMAL(13,4) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (tcode)
) ENGINE=InnoDB;

-- 唯一索引
CREATE UNIQUE INDEX index_rcfctcost_pkey ON rcfctcost (tdate, tterm, rcarea, rmno, rcitem);

-- 表: rccardi
DROP TABLE IF EXISTS rccardi;
CREATE TABLE rccardi (
    code VARCHAR(8) NOT NULL,
    ccode VARCHAR(8) NULL,
    persons SMALLINT NULL,
    rcitem VARCHAR(8) NULL,
    qty DECIMAL(13,4) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: rccard
DROP TABLE IF EXISTS rccard;
CREATE TABLE rccard (
    ccode VARCHAR(8) NOT NULL,
    chktype VARCHAR(1) NULL,
    rmtype VARCHAR(8) NULL,
    stdpax SMALLINT NULL,
    maxpax SMALLINT NULL,
    chkprd VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    prdcode VARCHAR(8) NULL,
    PRIMARY KEY (ccode)
) ENGINE=InnoDB;

-- 表: rcareasec
DROP TABLE IF EXISTS rcareasec;
CREATE TABLE rcareasec (
    building VARCHAR(8) NOT NULL,
    floor VARCHAR(8) NOT NULL,
    rcarea VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (building, floor)
) ENGINE=InnoDB;

-- 表: rcarea
DROP TABLE IF EXISTS rcarea;
CREATE TABLE rcarea (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    ivdept VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: rcadjust
DROP TABLE IF EXISTS rcadjust;
CREATE TABLE rcadjust (
    recid INT NOT NULL AUTO_INCREMENT,
    tterm VARCHAR(8) NULL,
    rcitem VARCHAR(8) NULL,
    qty DECIMAL(13,4) NULL,
    amt DECIMAL(12,2) NULL,
    PRIMARY KEY (recid)
) ENGINE=InnoDB;

-- 索引
CREATE INDEX IX_rcadjust ON rcadjust (recid);

-- 表: Punish
DROP TABLE IF EXISTS Punish;
CREATE TABLE Punish (
    emID INT NOT NULL,
    pnType VARCHAR(24) NOT NULL,
    pnTime DATETIME NOT NULL,
    pnReason VARCHAR(255) NULL,
    pnCompany VARCHAR(32) NULL,
    pnEndDate DATETIME NULL,
    pnEndReason VARCHAR(255) NULL,
    recNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (recNo)
) ENGINE=InnoDB;

-- 表: PRS
DROP TABLE IF EXISTS PRS;
CREATE TABLE PRS (
    prPeriod VARCHAR(8) NOT NULL,
    prIndex SMALLINT NOT NULL DEFAULT 0,
    emID INT NOT NULL,
    dtCode VARCHAR(12) NULL,
    I01 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I02 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I03 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I04 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I05 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I06 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I07 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I99 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A01 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A02 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A03 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A04 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A05 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A06 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A07 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A08 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A09 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A10 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A11 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A12 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A13 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A14 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A15 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A16 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A17 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A18 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A19 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A20 DECIMAL(19,4) NOT NULL DEFAULT 0,
    A99 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B01 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B02 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B03 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B04 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B05 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B06 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B07 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B08 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B09 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B10 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B11 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B12 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B13 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B14 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B15 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B16 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B17 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B18 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B19 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B20 DECIMAL(19,4) NOT NULL DEFAULT 0,
    B99 DECIMAL(19,4) NOT NULL DEFAULT 0,
    C99 DECIMAL(19,4) NOT NULL DEFAULT 0,
    prTag SMALLINT NOT NULL DEFAULT 0,
    I08 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I09 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I10 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I11 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I12 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I13 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I14 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I15 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I16 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I17 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I18 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I19 DECIMAL(19,4) NOT NULL DEFAULT 0,
    I20 DECIMAL(19,4) NOT NULL DEFAULT 0,
    PRIMARY KEY (prPeriod, prIndex, emID)
) ENGINE=InnoDB;

-- 表: ProvideItem
DROP TABLE IF EXISTS ProvideItem;
CREATE TABLE ProvideItem (
    emid INT NOT NULL,
    FsortId INT NOT NULL,
    ItemName VARCHAR(30) NULL,
    FNo VARCHAR(16) NULL,
    FUsedate DATETIME NULL,
    Foregift DECIMAL(8,2) NULL,
    PRIMARY KEY (emid, FsortId)
) ENGINE=InnoDB;

-- 表: property_acc
DROP TABLE IF EXISTS property_acc;
CREATE TABLE property_acc (
    property_lb VARCHAR(10) NOT NULL,
    property_ID VARCHAR(10) NOT NULL,
    property_name VARCHAR(50) NULL,
    PRIMARY KEY (property_lb, property_ID)
) ENGINE=InnoDB;

-- 表: prm_copy
DROP TABLE IF EXISTS prm_copy;
CREATE TABLE prm_copy (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    memo VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    class VARCHAR(8) NULL,
    descript VARCHAR(255) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: prm
DROP TABLE IF EXISTS prm;
CREATE TABLE prm (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    memo VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    class VARCHAR(8) NULL,
    descript VARCHAR(255) NULL,
    defval VARCHAR(255) NULL,
    seqid INT NULL DEFAULT 0,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: prd
DROP TABLE IF EXISTS prd;
CREATE TABLE prd (
    a_yymm VARCHAR(7) NOT NULL,
    a_desc VARCHAR(10) NULL,
    a_bdat DATETIME NULL,
    a_edat DATETIME NULL,
    a_stat VARCHAR(1) NULL,
    a_memo VARCHAR(30) NULL,
    a_stat_pur VARCHAR(1) NULL,
    a_stat_inv VARCHAR(1) NULL,
    a_stat_ap VARCHAR(1) NULL,
    a_stat_ar VARCHAR(1) NULL,
    a_stat_eqp VARCHAR(1) NULL,
    a_stat_rmc VARCHAR(1) NULL,
    PRIMARY KEY (a_yymm)
) ENGINE=InnoDB;

-- 表: signercode
DROP TABLE IF EXISTS signercode;
CREATE TABLE signercode (
    signid VARCHAR(8) NOT NULL,
    Signname VARCHAR(60) NULL,
    Photo VARCHAR(30) NULL,
    Memo VARCHAR(255) NULL,
    Flag VARCHAR(1) NULL,
    FisPub VARCHAR(1) NULL,
    PRIMARY KEY (signid)
) ENGINE=InnoDB;

-- 表: SettleMsg
DROP TABLE IF EXISTS SettleMsg;
CREATE TABLE SettleMsg (
    ID INT NOT NULL AUTO_INCREMENT,
    t_no DECIMAL(8,0) NOT NULL,
    folioid INT NOT NULL,
    charge DECIMAL(16,2) NOT NULL,
    payment DECIMAL(16,2) NOT NULL,
    settledate DATETIME NOT NULL,
    settler VARCHAR(50) NOT NULL,
    remarks VARCHAR(255) NULL,
    Issend VARCHAR(1) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB;

-- 表: runrec
DROP TABLE IF EXISTS runrec;
CREATE TABLE runrec (
    scode VARCHAR(8) NOT NULL,
    gcode VARCHAR(8) NOT NULL,
    rtime DATETIME NOT NULL,
    spec VARCHAR(80) NULL,
    shift VARCHAR(8) NULL,
    oper VARCHAR(8) NULL,
    memo VARCHAR(40) NULL,
    flag VARCHAR(1) NULL,
    d01 DECIMAL(10,1) NULL,
    d02 DECIMAL(10,1) NULL,
    d03 DECIMAL(10,1) NULL,
    d04 DECIMAL(10,1) NULL,
    d05 DECIMAL(10,1) NULL,
    d06 DECIMAL(10,1) NULL,
    d07 DECIMAL(10,1) NULL,
    d08 DECIMAL(10,1) NULL,
    d09 DECIMAL(10,1) NULL,
    d10 DECIMAL(10,1) NULL,
    d11 DECIMAL(10,1) NULL,
    d12 DECIMAL(10,1) NULL,
    d13 DECIMAL(10,1) NULL,
    d14 DECIMAL(10,1) NULL,
    d15 DECIMAL(10,1) NULL,
    d16 DECIMAL(10,1) NULL,
    d17 DECIMAL(10,1) NULL,
    d18 DECIMAL(10,1) NULL,
    d19 DECIMAL(10,1) NULL,
    d20 DECIMAL(10,1) NULL,
    d21 DECIMAL(10,1) NULL,
    d22 DECIMAL(10,1) NULL,
    d23 DECIMAL(10,1) NULL,
    d24 DECIMAL(10,1) NULL,
    d25 DECIMAL(10,1) NULL,
    d26 DECIMAL(10,1) NULL,
    d27 DECIMAL(10,1) NULL,
    d28 DECIMAL(10,1) NULL,
    d29 DECIMAL(10,1) NULL,
    d30 DECIMAL(10,1) NULL,
    d31 DECIMAL(10,1) NULL,
    d32 DECIMAL(10,1) NULL,
    d33 DECIMAL(10,1) NULL,
    d34 DECIMAL(10,1) NULL,
    d35 DECIMAL(10,1) NULL,
    d36 DECIMAL(10,1) NULL,
    d37 DECIMAL(10,1) NULL,
    d38 DECIMAL(10,1) NULL,
    d39 DECIMAL(10,1) NULL,
    d40 DECIMAL(10,1) NULL,
    d41 DECIMAL(10,1) NULL,
    d42 DECIMAL(10,1) NULL,
    d43 DECIMAL(10,1) NULL,
    d44 DECIMAL(10,1) NULL,
    d45 DECIMAL(10,1) NULL,
    d46 DECIMAL(10,1) NULL,
    d47 DECIMAL(10,1) NULL,
    d48 DECIMAL(10,1) NULL,
    d49 DECIMAL(10,1) NULL,
    d50 DECIMAL(10,1) NULL,
    d51 DECIMAL(10,1) NULL,
    d52 DECIMAL(10,1) NULL,
    d53 DECIMAL(10,1) NULL,
    d54 DECIMAL(10,1) NULL,
    d55 DECIMAL(10,1) NULL,
    d56 DECIMAL(10,1) NULL,
    d57 DECIMAL(10,1) NULL,
    d58 DECIMAL(10,1) NULL,
    d59 DECIMAL(10,1) NULL,
    d60 DECIMAL(10,1) NULL,
    PRIMARY KEY (scode, rtime, gcode)
) ENGINE=InnoDB;

-- 表: Rules
DROP TABLE IF EXISTS Rules;
CREATE TABLE Rules (
    ruName VARCHAR(60) NULL,
    ruTime DATETIME NULL,
    ruContent LONGBLOB NULL,
    ruDescript VARCHAR(255) NULL,
    ruMan VARCHAR(8) NULL,
    ruFlag VARCHAR(1) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: uDept
DROP TABLE IF EXISTS uDept;
CREATE TABLE uDept (
    DeptCode VARCHAR(8) NOT NULL,
    DeptParentCode VARCHAR(8) NULL,
    DeptName VARCHAR(30) NOT NULL,
    EName VARCHAR(30) NULL,
    Remarks VARCHAR(60) NULL,
    PRIMARY KEY (DeptCode),
    UNIQUE KEY AK_uDept_DeptName (DeptName),
    FOREIGN KEY (DeptParentCode) REFERENCES uDept (DeptCode)
) ENGINE=InnoDB;

-- 表: ToolTran
DROP TABLE IF EXISTS ToolTran;
CREATE TABLE ToolTran (
    TNo VARCHAR(8) NOT NULL,
    TClass VARCHAR(8) NULL,
    TDate DATETIME NULL,
    Descript VARCHAR(40) NOT NULL,
    Empl VARCHAR(8) NULL,
    Tool VARCHAR(8) NULL,
    Quantity DECIMAL(8,0) NULL,
    RefNo VARCHAR(8) NULL,
    Clerk VARCHAR(8) NULL,
    Notes VARCHAR(40) NOT NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (TNo)
) ENGINE=InnoDB;

-- 表: tno
DROP TABLE IF EXISTS tno;
CREATE TABLE tno (
    t_ym VARCHAR(7) NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    PRIMARY KEY (t_ym, t_class)
) ENGINE=InnoDB;

-- 表: Tech
DROP TABLE IF EXISTS Tech;
CREATE TABLE Tech (
    emID INT NOT NULL,
    teName VARCHAR(32) NULL,
    teMethod VARCHAR(24) NULL,
    teTime DATETIME NULL,
    tePosName VARCHAR(20) NULL,
    teBegin DATETIME NULL,
    teEnd DATETIME NULL,
    teCompany VARCHAR(32) NULL,
    teApprove VARCHAR(32) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: TaxRate
DROP TABLE IF EXISTS TaxRate;
CREATE TABLE TaxRate (
    trAmount DECIMAL(19,4) NOT NULL,
    trRate DECIMAL(5,3) NOT NULL,
    trReturn DECIMAL(19,4) NOT NULL DEFAULT 0,
    trMemo VARCHAR(32) NULL,
    recno INT NOT NULL AUTO_INCREMENT,
    trAmount0 DECIMAL(19,4) NOT NULL DEFAULT 0,
    PRIMARY KEY (recno)
) ENGINE=InnoDB;

-- 表: t_PrintMain
DROP TABLE IF EXISTS t_PrintMain;
CREATE TABLE t_PrintMain (
    FUserNo VARCHAR(8) NOT NULL,
    FDwName VARCHAR(50) NOT NULL,
    FPageSetNo INT NOT NULL,
    FPageSetValue VARCHAR(5000) NULL,
    PRIMARY KEY (FUserNo, FDwName, FPageSetNo)
) ENGINE=InnoDB;

-- 表: t_DwColumnWidth
DROP TABLE IF EXISTS t_DwColumnWidth;
CREATE TABLE t_DwColumnWidth (
    FUserNo VARCHAR(20) NOT NULL,
    Fdwname VARCHAR(100) NOT NULL,
    FCol VARCHAR(50) NOT NULL,
    FColWidth DECIMAL(12,0) NOT NULL,
    FColX DECIMAL(12,0) NOT NULL,
    PRIMARY KEY (FUserNo, Fdwname, FCol)
) ENGINE=InnoDB;

-- 表: syslog
DROP TABLE IF EXISTS syslog;
CREATE TABLE syslog (
    t_date DATETIME NOT NULL,
    t_user VARCHAR(8) NOT NULL,
    t_memo VARCHAR(240) NULL,
    t_flag VARCHAR(1) NULL,
    t_system VARCHAR(8) NULL,
    t_hostname VARCHAR(16) NULL,
    t_active VARCHAR(16) NULL,
    t_remark VARCHAR(255) NULL,
    PRIMARY KEY (t_date, t_user)
) ENGINE=InnoDB;

-- 表: Supplier
DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Country VARCHAR(8) NULL,
    Address VARCHAR(60) NULL,
    Zip VARCHAR(8) NULL,
    Tel VARCHAR(20) NULL,
    Fax VARCHAR(20) NULL,
    Url VARCHAR(40) NULL,
    Email VARCHAR(40) NULL,
    Contact VARCHAR(20) NULL,
    BankAcnt VARCHAR(30) NULL,
    TaxId VARCHAR(30) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: suit
DROP TABLE IF EXISTS suit;
CREATE TABLE suit (
    s_no VARCHAR(8) NOT NULL,
    s_name VARCHAR(40) NULL,
    s_dir VARCHAR(80) NULL,
    s_flag VARCHAR(1) NULL,
    s_bdat DATETIME NULL,
    s_edat DATETIME NULL,
    s_memo VARCHAR(200) NULL,
    PRIMARY KEY (s_no)
) ENGINE=InnoDB;

-- 表: stock
DROP TABLE IF EXISTS stock;
CREATE TABLE stock (
    id DECIMAL(16,0) NOT NULL AUTO_INCREMENT,
    Date DATETIME NOT NULL,
    Name VARCHAR(40) NULL,
    Model VARCHAR(20) NULL,
    Unit VARCHAR(8) NULL,
    Department VARCHAR(8) NULL,
    ItemNo VARCHAR(20) NULL,
    sumpri DECIMAL(16,2) NULL,
    sumqty DECIMAL(8,0) NULL,
    sumamt DECIMAL(16,2) NULL,
    Quantity DECIMAL(8,0) NULL,
    Amount DECIMAL(16,2) NULL,
    Memo VARCHAR(255) NULL,
    EquipNo VARCHAR(20) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- 表: Station
DROP TABLE IF EXISTS Station;
CREATE TABLE Station (
    emID INT NOT NULL,
    stName VARCHAR(24) NULL,
    stTime DATETIME NULL,
    stMethod VARCHAR(24) NULL,
    stMemo VARCHAR(40) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    stLevel VARCHAR(24) NULL,
    stNameb VARCHAR(24) NULL,
    stLevelb VARCHAR(24) NULL,
    dtCode VARCHAR(12) NULL,
    dtCodeb VARCHAR(12) NULL,
    wgOrignal DECIMAL(19,4) NULL,
    wgCurrent DECIMAL(19,4) NULL,
    stTime1 DATETIME NULL,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: sOperaLog
DROP TABLE IF EXISTS sOperaLog;
CREATE TABLE sOperaLog (
    ID INT NOT NULL AUTO_INCREMENT,
    AppID INT NULL,
    Clerk VARCHAR(8) NULL,
    LogTime DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    WorkStation VARCHAR(50) NULL,
    LogType INT NULL,
    AccID VARCHAR(20) NULL,
    ItemID VARCHAR(8) NULL,
    RMNO VARCHAR(18) NULL,
    KeyID VARCHAR(100) NULL,
    Actions VARCHAR(250) NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB;

-- 表: pr_rmnow
DROP TABLE IF EXISTS pr_rmnow;
CREATE TABLE pr_rmnow (
    rmcode VARCHAR(6) NOT NULL,
    rmtypecode VARCHAR(4) NULL,
    buildingcode VARCHAR(4) NULL,
    buildingname VARCHAR(10) NULL,
    RmState VARCHAR(4) NULL,
    GstState VARCHAR(4) NULL,
    Exp SMALLINT NULL,
    DueOut SMALLINT NULL,
    GstTypeCode VARCHAR(4) NULL,
    Spec SMALLINT NULL,
    GstIsVip SMALLINT NULL,
    RmMemo VARCHAR(20) NULL,
    RmSdate DATETIME NULL,
    RmEdate DATETIME NULL,
    RmClass VARCHAR(4) NULL,
    RmMsg VARCHAR(255) NULL,
    PRIMARY KEY (rmcode)
) ENGINE=InnoDB;

-- 表: PMTasks
DROP TABLE IF EXISTS PMTasks;
CREATE TABLE PMTasks (
    TaskNo VARCHAR(8) NOT NULL,
    TaskName VARCHAR(40) NULL,
    Cycle VARCHAR(8) NULL,
    Class VARCHAR(8) NULL,
    Descript VARCHAR(80) NULL,
    Priority DECIMAL(8,2) NULL,
    EquipNo VARCHAR(20) NULL,
    Location VARCHAR(8) NULL,
    Department VARCHAR(8) NULL,
    Craft VARCHAR(8) NULL,
    Pax DECIMAL(8,0) NULL,
    ManHours DECIMAL(8,2) NULL,
    Parts DECIMAL(16,2) NULL,
    HoursFee DECIMAL(16,2) NULL,
    Overhead DECIMAL(16,2) NULL,
    DownTime DECIMAL(8,2) NULL,
    StartDate DATETIME NULL,
    FinishDate DATETIME NULL,
    Notes VARCHAR(80) NULL,
    Status VARCHAR(8) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (TaskNo)
) ENGINE=InnoDB;

-- 表: pmt
DROP TABLE IF EXISTS pmt;
CREATE TABLE pmt (
    p_no VARCHAR(8) NOT NULL,
    p_name VARCHAR(30) NULL,
    p_type VARCHAR(8) NULL,
    p_memo VARCHAR(30) NULL,
    p_flag VARCHAR(1) NULL,
    PRIMARY KEY (p_no)
) ENGINE=InnoDB;

-- 表: phr
DROP TABLE IF EXISTS phr;
CREATE TABLE phr (
    code VARCHAR(4) NOT NULL,
    name VARCHAR(30) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: PersonType
DROP TABLE IF EXISTS PersonType;
CREATE TABLE PersonType (
    ptCode VARCHAR(8) NOT NULL,
    ptName VARCHAR(24) NULL,
    ptMemo VARCHAR(32) NULL,
    PRIMARY KEY (ptCode)
) ENGINE=InnoDB;

-- 表: pcode
DROP TABLE IF EXISTS pcode;
CREATE TABLE pcode (
    pcode VARCHAR(6) NOT NULL,
    address VARCHAR(30) NULL,
    readercount DECIMAL(8,0) NULL,
    telepref VARCHAR(10) NULL,
    PRIMARY KEY (pcode)
) ENGINE=InnoDB;

-- 表: pbcatvld
DROP TABLE IF EXISTS pbcatvld;
CREATE TABLE pbcatvld (
    pbv_name VARCHAR(30) NOT NULL,
    pbv_vald VARCHAR(254) NOT NULL,
    pbv_type SMALLINT NOT NULL,
    pbv_cntr INT NULL,
    pbv_msg VARCHAR(254) NULL,
    PRIMARY KEY (pbv_name)
) ENGINE=InnoDB;

-- 表: pbcattbl
DROP TABLE IF EXISTS pbcattbl;
CREATE TABLE pbcattbl (
    pbt_tnam VARCHAR(30) NULL,
    pbt_tid INT NULL,
    pbt_ownr VARCHAR(30) NULL,
    pbd_fhgt SMALLINT NULL,
    pbd_fwgt SMALLINT NULL,
    pbd_fitl VARCHAR(1) NULL,
    pbd_funl VARCHAR(1) NULL,
    pbd_fchr SMALLINT NULL,
    pbd_fptc SMALLINT NULL,
    pbd_ffce VARCHAR(32) NULL,
    pbh_fhgt SMALLINT NULL,
    pbh_fwgt SMALLINT NULL,
    pbh_fitl VARCHAR(1) NULL,
    pbh_funl VARCHAR(1) NULL,
    pbh_fchr SMALLINT NULL,
    pbh_fptc SMALLINT NULL,
    pbh_ffce VARCHAR(32) NULL,
    pbl_fhgt SMALLINT NULL,
    pbl_fwgt SMALLINT NULL,
    pbl_fitl VARCHAR(1) NULL,
    pbl_funl VARCHAR(1) NULL,
    pbl_fchr SMALLINT NULL,
    pbl_fptc SMALLINT NULL,
    pbl_ffce VARCHAR(32) NULL,
    pbt_cmnt VARCHAR(254) NULL,
    UNIQUE KEY pbcattbl_idx (pbt_tnam, pbt_ownr)
) ENGINE=InnoDB;

-- 表: pbcatfmt
DROP TABLE IF EXISTS pbcatfmt;
CREATE TABLE pbcatfmt (
    pbf_name VARCHAR(30) NOT NULL,
    pbf_frmt VARCHAR(254) NOT NULL,
    pbf_type SMALLINT NOT NULL,
    pbf_cntr INT NULL,
    PRIMARY KEY (pbf_name)
) ENGINE=InnoDB;

-- 表: pbcatedt
DROP TABLE IF EXISTS pbcatedt;
CREATE TABLE pbcatedt (
    pbe_name VARCHAR(30) NOT NULL,
    pbe_edit VARCHAR(254) NULL,
    pbe_type SMALLINT NOT NULL,
    pbe_cntr INT NULL,
    pbe_seqn SMALLINT NOT NULL,
    pbe_flag INT NULL,
    pbe_work VARCHAR(32) NULL,
    PRIMARY KEY (pbe_name, pbe_seqn)
) ENGINE=InnoDB;

-- 表: pbcatcol
DROP TABLE IF EXISTS pbcatcol;
CREATE TABLE pbcatcol (
    pbc_tnam VARCHAR(30) NULL,
    pbc_tid INT NULL,
    pbc_ownr VARCHAR(30) NULL,
    pbc_cnam VARCHAR(30) NULL,
    pbc_cid SMALLINT NULL,
    pbc_labl VARCHAR(254) NULL,
    pbc_lpos SMALLINT NULL,
    pbc_hdr VARCHAR(254) NULL,
    pbc_hpos SMALLINT NULL,
    pbc_jtfy SMALLINT NULL,
    pbc_mask VARCHAR(31) NULL,
    pbc_case SMALLINT NULL,
    pbc_hght SMALLINT NULL,
    pbc_wdth SMALLINT NULL,
    pbc_ptrn VARCHAR(31) NULL,
    pbc_bmap VARCHAR(1) NULL,
    pbc_init VARCHAR(254) NULL,
    pbc_cmnt VARCHAR(254) NULL,
    pbc_edit VARCHAR(31) NULL,
    pbc_tag VARCHAR(254) NULL,
    UNIQUE KEY pbcatcol_idx (pbc_tnam, pbc_ownr, pbc_cnam)
) ENGINE=InnoDB;

-- 表: OtherCode
DROP TABLE IF EXISTS OtherCode;
CREATE TABLE OtherCode (
    ocCode VARCHAR(8) NOT NULL,
    ocName VARCHAR(24) NULL,
    ocMemo VARCHAR(255) NULL,
    ocFlag INT NOT NULL DEFAULT 1,
    PRIMARY KEY (ocCode)
) ENGINE=InnoDB;

-- 表: mnu
DROP TABLE IF EXISTS mnu;
CREATE TABLE mnu (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(20) NULL,
    pswd VARCHAR(8) NULL,
    auth VARCHAR(80) NULL,
    dept VARCHAR(8) NULL,
    duty VARCHAR(8) NULL,
    memo VARCHAR(40) NULL,
    flag VARCHAR(1) NULL,
    eventflag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Material
DROP TABLE IF EXISTS Material;
CREATE TABLE Material (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Model VARCHAR(20) NULL,
    Unit VARCHAR(8) NULL,
    Quantity DECIMAL(10,2) NULL,
    Price DECIMAL(16,2) NULL,
    Amount DECIMAL(16,2) NULL,
    Factory VARCHAR(8) NULL,
    SpareModel VARCHAR(20) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    barcode VARCHAR(20) NULL,
    EquipNo VARCHAR(20) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: language
DROP TABLE IF EXISTS language;
CREATE TABLE language (
    lang_cn VARCHAR(255) NOT NULL,
    lang_en VARCHAR(255) NULL,
    lang_tw VARCHAR(255) NULL,
    PRIMARY KEY (lang_cn)
) ENGINE=InnoDB;

-- 表: jsdbf
DROP TABLE IF EXISTS jsdbf;
CREATE TABLE jsdbf (
    date VARCHAR(8) NOT NULL,
    time VARCHAR(4) NOT NULL,
    ic_no VARCHAR(5) NOT NULL,
    qf_no VARCHAR(7) NOT NULL,
    sf_no VARCHAR(2) NOT NULL,
    cz_no VARCHAR(5) NOT NULL,
    money DECIMAL(7,2) NOT NULL,
    over_je DECIMAL(7,2) NOT NULL,
    bj VARCHAR(1) NOT NULL,
    PRIMARY KEY (date, time, ic_no, money, over_je)
) ENGINE=InnoDB;

-- 表: ivwrhs
DROP TABLE IF EXISTS ivwrhs;
CREATE TABLE ivwrhs (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    manager VARCHAR(10) NULL,
    place VARCHAR(20) NULL,
    area DECIMAL(8,0) NULL,
    accno VARCHAR(12) NULL,
    levels DECIMAL(1,0) NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    wrhslevel VARCHAR(8) NULL,
    wrhsstat VARCHAR(1) NULL,
    ictowi VARCHAR(1) NULL,
    widept VARCHAR(8) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ivusage
DROP TABLE IF EXISTS ivusage;
CREATE TABLE ivusage (
    ivcost VARCHAR(8) NOT NULL,
    ivdept VARCHAR(8) NOT NULL,
    ivitem VARCHAR(16) NOT NULL,
    a_no VARCHAR(16) NOT NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    dflt VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL
) ENGINE=InnoDB;

-- 表: ivtype
DROP TABLE IF EXISTS ivtype;
CREATE TABLE ivtype (
    code VARCHAR(2) NOT NULL,
    name VARCHAR(8) NULL,
    describ VARCHAR(30) NULL,
    sheet VARCHAR(30) NULL,
    counter VARCHAR(10) NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    frlocation VARCHAR(1) NULL,
    tolocation VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ivtranlog
DROP TABLE IF EXISTS ivtranlog;
CREATE TABLE ivtranlog (
    logid INT NOT NULL AUTO_INCREMENT,
    tcode VARCHAR(10) NULL,
    tdate DATETIME NULL,
    tplid INT NULL,
    tplline INT NULL,
    usr VARCHAR(8) NULL,
    acting VARCHAR(50) NULL,
    remark VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (logid)
) ENGINE=InnoDB;

CREATE INDEX ivtranlog_tcode ON ivtranlog (tcode);
CREATE INDEX ivtranlog_tplid ON ivtranlog (tplid);
CREATE INDEX ivtranlog_tplline ON ivtranlog (tplline);

-- 表: ivtrani_template
DROP TABLE IF EXISTS ivtrani_template;
CREATE TABLE ivtrani_template (
    tcode VARCHAR(10) NOT NULL,
    ttype VARCHAR(8) NULL,
    tline VARCHAR(10) NOT NULL,
    item VARCHAR(16) NULL,
    lot VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    price DECIMAL(16,6) NULL,
    amt DECIMAL(12,2) NULL,
    expdate DATETIME NULL,
    usage VARCHAR(10) NULL,
    qty0 DECIMAL(13,4) NULL,
    memo VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    Amortizeflag VARCHAR(1) NULL,
    stkqty DECIMAL(13,4) NULL,
    pieqty DECIMAL(13,4) NULL,
    curprice DECIMAL(16,6) NULL,
    preprice DECIMAL(16,6) NULL,
    price1 DECIMAL(16,6) NULL,
    price2 DECIMAL(16,6) NULL,
    price3 DECIMAL(16,6) NULL,
    Fisclose VARCHAR(1) NULL,
    pieqty0 DECIMAL(13,4) NULL,
    FselVndr VARCHAR(8) NULL,
    outusage VARCHAR(10) NULL,
    reftcode VARCHAR(10) NULL,
    factamt DECIMAL(12,2) NULL,
    accamt DECIMAL(12,2) NULL,
    accno VARCHAR(16) NULL,
    PRIMARY KEY (tcode, tline)
) ENGINE=InnoDB;

-- 表: ivtrani
DROP TABLE IF EXISTS ivtrani;
CREATE TABLE ivtrani (
    tcode VARCHAR(10) NULL,
    ttype VARCHAR(8) NULL,
    tline VARCHAR(10) NOT NULL,
    item VARCHAR(16) NULL,
    lot VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    price DECIMAL(16,6) NULL,
    amt DECIMAL(12,2) NULL,
    expdate DATETIME NULL,
    usage VARCHAR(10) NULL,
    qty0 DECIMAL(13,4) NULL,
    memo VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    Amortizeflag VARCHAR(1) NULL,
    stkqty DECIMAL(13,4) NULL,
    pieqty DECIMAL(13,4) NULL,
    curprice DECIMAL(16,6) NULL,
    preprice DECIMAL(16,6) NULL,
    price1 DECIMAL(16,6) NULL,
    price2 DECIMAL(16,6) NULL,
    price3 DECIMAL(16,6) NULL,
    Fisclose VARCHAR(1) NULL,
    pieqty0 DECIMAL(13,4) NULL,
    FselVndr VARCHAR(8) NULL,
    outusage VARCHAR(10) NULL,
    reftcode VARCHAR(10) NULL,
    factamt DECIMAL(12,2) NULL,
    accamt DECIMAL(12,2) NULL,
    accno VARCHAR(16) NULL,
    PRIMARY KEY (tline)
) ENGINE=InnoDB;

CREATE INDEX ivtrani_price ON ivtrani (price, tcode);
CREATE INDEX ivtrani_amt ON ivtrani (tcode, amt);
CREATE INDEX ivtrani_item ON ivtrani (item);
CREATE INDEX ivtrani_tcode ON ivtrani (tcode);
CREATE INDEX ivtrani_ttype ON ivtrani (ttype);
CREATE INDEX ivtrani_typeamt ON ivtrani (ttype, tcode, amt);

-- 表: ivtrandoc
DROP TABLE IF EXISTS ivtrandoc;
CREATE TABLE ivtrandoc (
    docid INT NOT NULL AUTO_INCREMENT,
    tcode VARCHAR(10) NULL,
    docname VARCHAR(255) NULL,
    docpath VARCHAR(255) NULL,
    filetime DATETIME NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (docid)
) ENGINE=InnoDB;

-- 表: ivtran_template
DROP TABLE IF EXISTS ivtran_template;
CREATE TABLE ivtran_template (
    tcode VARCHAR(10) NOT NULL,
    ttype VARCHAR(8) NULL,
    tname VARCHAR(80) NULL,
    tdate DATETIME NULL,
    vndr VARCHAR(16) NULL,
    wrhs VARCHAR(16) NULL,
    dept VARCHAR(16) NULL,
    refno VARCHAR(10) NULL,
    arrdate DATETIME NULL,
    apitem VARCHAR(8) NULL,
    invoice VARCHAR(10) NULL,
    man1 VARCHAR(8) NULL,
    man2 VARCHAR(8) NULL,
    man3 VARCHAR(8) NULL,
    man4 VARCHAR(8) NULL,
    man5 VARCHAR(8) NULL,
    pstdate DATETIME NULL,
    status VARCHAR(1) NULL DEFAULT '0',
    memo VARCHAR(80) NULL,
    flag VARCHAR(1) NULL,
    editor VARCHAR(8) NULL,
    delivertype VARCHAR(4) NULL,
    trnstat VARCHAR(1) NULL,
    crtstat VARCHAR(1) NULL,
    tplid INT NULL,
    tplline INT NULL,
    autogen VARCHAR(1) NULL,
    ivadttype VARCHAR(8) NULL,
    refno0 VARCHAR(10) NULL,
    prtcount INT NULL,
    apno DECIMAL(8,0) NULL,
    pricedate DATETIME NULL,
    prvndr1 VARCHAR(16) NULL,
    prvndr2 VARCHAR(16) NULL,
    prvndr3 VARCHAR(16) NULL,
    fistmp VARCHAR(1) NULL,
    PRIMARY KEY (tcode)
) ENGINE=InnoDB;

-- 表: ivtran
DROP TABLE IF EXISTS ivtran;
CREATE TABLE ivtran (
    tcode VARCHAR(10) NOT NULL,
    ttype VARCHAR(8) NULL,
    tdate DATETIME NULL,
    vndr VARCHAR(16) NULL,
    wrhs VARCHAR(16) NULL,
    dept VARCHAR(16) NULL,
    refno VARCHAR(10) NULL,
    arrdate DATETIME NULL,
    apitem VARCHAR(8) NULL,
    invoice VARCHAR(10) NULL,
    man1 VARCHAR(8) NULL,
    man2 VARCHAR(8) NULL,
    man3 VARCHAR(8) NULL,
    man4 VARCHAR(8) NULL,
    man5 VARCHAR(8) NULL,
    pstdate DATETIME NULL,
    status VARCHAR(1) NULL DEFAULT '0',
    memo VARCHAR(80) NULL,
    flag VARCHAR(1) NULL,
    editor VARCHAR(8) NULL,
    delivertype VARCHAR(4) NULL,
    trnstat VARCHAR(1) NULL,
    crtstat VARCHAR(1) NULL,
    tplid INT NULL,
    tplline INT NULL,
    autogen VARCHAR(1) NULL,
    ivadttype VARCHAR(8) NULL,
    refno0 VARCHAR(10) NULL,
    prtcount INT NULL,
    apno DECIMAL(8,0) NULL,
    pricedate DATETIME NULL,
    prvndr1 VARCHAR(16) NULL,
    prvndr2 VARCHAR(16) NULL,
    prvndr3 VARCHAR(16) NULL,
    fistmp VARCHAR(1) NULL,
    DiscardType VARCHAR(8) NULL,
    PRIMARY KEY (tcode)
) ENGINE=InnoDB;

CREATE INDEX ivtran_status ON ivtran (status, ttype);
CREATE INDEX ivtran_refno ON ivtran (refno);
CREATE INDEX ivtran_tdate ON ivtran (tdate);
CREATE INDEX ivtran_ttype ON ivtran (ttype);

-- 表: ivtracer
DROP TABLE IF EXISTS ivtracer;
CREATE TABLE ivtracer (
    Pretcode VARCHAR(10) NOT NULL,
    Prettype VARCHAR(8) NULL,
    Postcode VARCHAR(10) NOT NULL,
    Posttype VARCHAR(8) NULL,
    PRIMARY KEY (Pretcode, Postcode)
) ENGINE=InnoDB;

-- 表: ivstock
DROP TABLE IF EXISTS ivstock;
CREATE TABLE ivstock (
    tcode VARCHAR(10) NOT NULL,
    tdate DATETIME NULL,
    location VARCHAR(8) NULL,
    item VARCHAR(16) NULL,
    lot VARCHAR(10) NULL,
    qty DECIMAL(13,4) NULL,
    price DECIMAL(16,6) NULL,
    amt DECIMAL(12,2) NULL,
    expdate DATETIME NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    pieqty DECIMAL(13,4) NULL,
    PRIMARY KEY (tcode)
) ENGINE=InnoDB;

CREATE INDEX ivstock_item ON ivstock (item);
CREATE INDEX ivstock_location ON ivstock (location);
CREATE INDEX ivstock_tdate ON ivstock (tdate);

-- 表: ivitembc
DROP TABLE IF EXISTS ivitembc;
CREATE TABLE ivitembc (
    item VARCHAR(16) NOT NULL,
    barcode VARCHAR(50) NOT NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (item, barcode)
) ENGINE=InnoDB;

-- 表: ivitem
DROP TABLE IF EXISTS ivitem;
CREATE TABLE ivitem (
    code VARCHAR(16) NOT NULL,
    name VARCHAR(80) NULL,
    category VARCHAR(16) NULL,
    spec VARCHAR(80) NULL,
    unit VARCHAR(8) NULL,
    maxqty DECIMAL(13,4) NULL,
    minqty DECIMAL(13,4) NULL,
    reorder DECIMAL(13,4) NULL,
    costing VARCHAR(10) NULL,
    accno VARCHAR(12) NULL,
    accnos VARCHAR(500) NULL,
    levels DECIMAL(1,0) NULL,
    stat VARCHAR(1) NULL,
    memo VARCHAR(200) NULL,
    flag VARCHAR(1) NULL,
    priceedit VARCHAR(1) NULL,
    usage VARCHAR(8) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust4s VARCHAR(500) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    piece VARCHAR(1) NULL,
    semigoods VARCHAR(1) NULL,
    wrhs VARCHAR(8) NULL,
    accprec VARCHAR(1) NULL,
    pieunit VARCHAR(30) NULL,
    cvrnum DECIMAL(13,4) NULL,
    photo VARCHAR(128) NULL,
    GoodsNo VARCHAR(8) NULL,
    pvftrate DECIMAL(7,4) NULL,
    oqnum DECIMAL(13,4) NULL,
    purunit VARCHAR(10) NULL,
    convrate DECIMAL(18,4) NULL,
    ahnum INT NULL DEFAULT 0,
    movedays INT NULL,
    Overacc VARCHAR(12) NULL,
    wrhsstat VARCHAR(1) NULL,
    pym VARCHAR(50) NULL,
    En_Name VARCHAR(80) NULL,
    En_Spec VARCHAR(80) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ivcost
DROP TABLE IF EXISTS ivcost;
CREATE TABLE ivcost (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    accno VARCHAR(12) NULL,
    levels DECIMAL(1,0) NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ivadttype
DROP TABLE IF EXISTS ivadttype;
CREATE TABLE ivadttype (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ivadttpli
DROP TABLE IF EXISTS ivadttpli;
CREATE TABLE ivadttpli (
    tplline INT NOT NULL AUTO_INCREMENT,
    tplid INT NULL,
    stepcode VARCHAR(8) NULL,
    stepname VARCHAR(50) NULL,
    adtpsn VARCHAR(255) NULL,
    bydept VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (tplline)
) ENGINE=InnoDB;

-- 表: ivadttpl
DROP TABLE IF EXISTS ivadttpl;
CREATE TABLE ivadttpl (
    tplid INT NOT NULL AUTO_INCREMENT,
    tplname VARCHAR(50) NULL,
    ivtype VARCHAR(8) NULL,
    ivadttype VARCHAR(8) NULL,
    amttype VARCHAR(1) NULL,
    begamt DECIMAL(12,2) NULL,
    endamt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (tplid)
) ENGINE=InnoDB;

-- 表: InsureInfo
DROP TABLE IF EXISTS InsureInfo;
CREATE TABLE InsureInfo (
    emid INT NOT NULL,
    FsortId INT NOT NULL,
    Insuretype VARCHAR(20) NULL,
    FPaydate DATETIME NULL,
    Reason VARCHAR(100) NULL,
    Payformoney DECIMAL(10,2) NULL,
    Defraymoney DECIMAL(10,2) NULL,
    PRIMARY KEY (emid, FsortId)
) ENGINE=InnoDB;

-- 表: holiday
DROP TABLE IF EXISTS holiday;
CREATE TABLE holiday (
    hdate DATETIME NOT NULL,
    hname VARCHAR(20) NULL,
    notes VARCHAR(40) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (hdate)
) ENGINE=InnoDB;

-- 表: Health
DROP TABLE IF EXISTS Health;
CREATE TABLE Health (
    emID INT NOT NULL,
    hlDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hlHeight VARCHAR(10) NULL,
    hlWeight VARCHAR(10) NULL,
    hlEyeLeft VARCHAR(16) NULL,
    hlEyeRight VARCHAR(16) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: fxi
DROP TABLE IF EXISTS fxi;
CREATE TABLE fxi (
    f_no VARCHAR(8) NOT NULL,
    f_ym VARCHAR(7) NOT NULL,
    f_rateb DECIMAL(16,4) NULL,
    f_ratea DECIMAL(16,4) NULL,
    f_memo VARCHAR(30) NULL,
    f_flag VARCHAR(1) NULL,
    PRIMARY KEY (f_no, f_ym)
) ENGINE=InnoDB;

-- 表: fx
DROP TABLE IF EXISTS fx;
CREATE TABLE fx (
    f_no VARCHAR(8) NOT NULL,
    f_name VARCHAR(30) NOT NULL,
    f_sign VARCHAR(8) NULL,
    f_rate DECIMAL(16,4) NULL,
    f_flag VARCHAR(1) NULL,
    f_meth VARCHAR(1) NULL,
    f_memo VARCHAR(30) NULL,
    PRIMARY KEY (f_no)
) ENGINE=InnoDB;

-- 表: fcunitcvr
DROP TABLE IF EXISTS fcunitcvr;
CREATE TABLE fcunitcvr (
    cline INT NOT NULL AUTO_INCREMENT,
    srcunit VARCHAR(30) NULL,
    tarunit VARCHAR(30) NULL,
    cvrnum DECIMAL(13,4) NULL,
    untype VARCHAR(20) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (cline),
    UNIQUE KEY index_srcunittarunit (srcunit, tarunit)
) ENGINE=InnoDB;

-- 表: fcstdrcp
DROP TABLE IF EXISTS fcstdrcp;
CREATE TABLE fcstdrcp (
    rcpid INT NOT NULL AUTO_INCREMENT,
    rcpname VARCHAR(50) NULL,
    rcptype VARCHAR(8) NULL,
    procitem VARCHAR(8) NULL,
    begdate DATETIME NULL,
    enddate DATETIME NULL,
    isvalid VARCHAR(1) NULL,
    ingramt DECIMAL(12,2) NULL,
    oddamt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    begprd VARCHAR(8) NULL,
    endprd VARCHAR(8) NULL,
    PRIMARY KEY (rcpid)
) ENGINE=InnoDB;

-- 表: fcsDeptmrp
DROP TABLE IF EXISTS fcsDeptmrp;
CREATE TABLE fcsDeptmrp (
    fcline INT NOT NULL AUTO_INCREMENT,
    DeptID INT NOT NULL,
    ivdept VARCHAR(8) NOT NULL,
    memo VARCHAR(255) NULL,
    PRIMARY KEY (fcline)
) ENGINE=InnoDB;

-- 表: fcreportdata
DROP TABLE IF EXISTS fcreportdata;
CREATE TABLE fcreportdata (
    Fcline INT NOT NULL AUTO_INCREMENT,
    Fcprd VARCHAR(8) NOT NULL,
    Fbdept VARCHAR(8) NOT NULL,
    Fbdeptname VARCHAR(50) NOT NULL,
    Fitemcode VARCHAR(8) NOT NULL,
    Fitemname VARCHAR(50) NOT NULL,
    Fsaleamt DECIMAL(14,2) NULL,
    Fcostamt DECIMAL(14,2) NULL,
    Fstdamt DECIMAL(14,2) NULL,
    Ftype VARCHAR(1) NOT NULL,
    PRIMARY KEY (Fcline)
) ENGINE=InnoDB;

-- 表: fcproc
DROP TABLE IF EXISTS fcproc;
CREATE TABLE fcproc (
    procid INT NOT NULL AUTO_INCREMENT,
    rcpid INT NULL,
    tdate DATETIME NULL,
    tpsn VARCHAR(20) NULL,
    dept VARCHAR(8) NULL,
    stat VARCHAR(1) NULL,
    amt DECIMAL(12,2) NULL,
    oddamt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    PRIMARY KEY (procid)
) ENGINE=InnoDB;

-- 表: fcprd
DROP TABLE IF EXISTS fcprd;
CREATE TABLE fcprd (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    begdate DATETIME NULL,
    enddate DATETIME NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: fcpDeptmrp
DROP TABLE IF EXISTS fcpDeptmrp;
CREATE TABLE fcpDeptmrp (
    fcline INT NOT NULL AUTO_INCREMENT,
    DeptCode VARCHAR(8) NOT NULL,
    ivdept VARCHAR(8) NOT NULL,
    memo VARCHAR(255) NULL,
    PRIMARY KEY (fcline)
) ENGINE=InnoDB;

-- 表: fcobjmrp
DROP TABLE IF EXISTS fcobjmrp;
CREATE TABLE fcobjmrp (
    cline INT NOT NULL AUTO_INCREMENT,
    fcobject VARCHAR(8) NULL,
    ivdept VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    ivwrhs VARCHAR(8) NULL,
    PRIMARY KEY (cline),
    UNIQUE KEY index_fcobjivdept (fcobject, ivdept)
) ENGINE=InnoDB;

-- 表: fcobjfbm
DROP TABLE IF EXISTS fcobjfbm;
CREATE TABLE fcobjfbm (
    cline INT NOT NULL AUTO_INCREMENT,
    fcobject VARCHAR(8) NULL,
    fbdept VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (cline),
    UNIQUE KEY index_fcobjfbdept (fcobject, fbdept)
) ENGINE=InnoDB;

-- 表: fcobject
DROP TABLE IF EXISTS fcobject;
CREATE TABLE fcobject (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(50) NULL,
    clas VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: fcitemmrp
DROP TABLE IF EXISTS fcitemmrp;
CREATE TABLE fcitemmrp (
    cline INT NOT NULL AUTO_INCREMENT,
    fcitem VARCHAR(8) NULL,
    ivdept VARCHAR(8) NULL,
    ivitem VARCHAR(16) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (cline),
    UNIQUE KEY index_fcitemivdeptivitem (fcitem, ivdept, ivitem)
) ENGINE=InnoDB;

-- 表: fcitemfbm
DROP TABLE IF EXISTS fcitemfbm;
CREATE TABLE fcitemfbm (
    cline INT NOT NULL AUTO_INCREMENT,
    fcitem VARCHAR(8) NULL,
    fbitem VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (cline),
    UNIQUE KEY index_fcitemfbitem (fcitem, fbitem)
) ENGINE=InnoDB;

-- 表: fcitem
DROP TABLE IF EXISTS fcitem;
CREATE TABLE fcitem (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    clas VARCHAR(8) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: fccodes
DROP TABLE IF EXISTS fccodes;
CREATE TABLE fccodes (
    category VARCHAR(8) NOT NULL,
    code VARCHAR(8) NOT NULL,
    cname VARCHAR(30) NULL,
    ename VARCHAR(30) NULL,
    remarks VARCHAR(30) NULL,
    flag VARCHAR(1) NULL DEFAULT '1',
    seqid INT NULL DEFAULT 0,
    PRIMARY KEY (category, code)
) ENGINE=InnoDB;

-- 表: arcurr
DROP TABLE IF EXISTS arcurr;
CREATE TABLE arcurr (
    code VARCHAR(4) NOT NULL,
    name VARCHAR(10) NOT NULL,
    ename VARCHAR(20) NULL,
    xrate DECIMAL(10,6) NULL,
    begdt DATETIME NULL,
    enddt DATETIME NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: arcorr
DROP TABLE IF EXISTS arcorr;
CREATE TABLE arcorr (
    ardept VARCHAR(8) NOT NULL,
    arcust VARCHAR(16) NOT NULL,
    a_no VARCHAR(16) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    memo VARCHAR(16) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (ardept, arcust)
) ENGINE=InnoDB;

-- 表: arapi
DROP TABLE IF EXISTS arapi;
CREATE TABLE arapi (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no DECIMAL(4,0) NULL,
    t_xacc VARCHAR(16) NULL,
    t_ref VARCHAR(8) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NULL,
    t_cr DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_flag VARCHAR(1) NULL,
    t_cust VARCHAR(16) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: arap
DROP TABLE IF EXISTS arap;
CREATE TABLE arap (
    a_no VARCHAR(16) NOT NULL,
    a_name VARCHAR(30) NULL,
    a_bal DECIMAL(16,2) NULL,
    PRIMARY KEY (a_no)
) ENGINE=InnoDB;

-- 表: apwoff
DROP TABLE IF EXISTS apwoff;
CREATE TABLE apwoff (
    w_no DECIMAL(8,0) NOT NULL,
    t_no DECIMAL(8,0) NOT NULL,
    w_date DATETIME NULL,
    w_par VARCHAR(30) NULL,
    w_amt DECIMAL(16,2) NULL,
    w_dir VARCHAR(1) NULL,
    w_man VARCHAR(8) NULL,
    PRIMARY KEY (w_no, t_no)
) ENGINE=InnoDB;

-- 表: aptranother
DROP TABLE IF EXISTS aptranother;
CREATE TABLE aptranother (
    t_no DECIMAL(8,0) NOT NULL,
    accno VARCHAR(16) NOT NULL,
    amt DECIMAL(16,2) NOT NULL,
    Memo VARCHAR(255) NULL,
    PRIMARY KEY (t_no, accno)
) ENGINE=InnoDB;

-- 表: aptran
DROP TABLE IF EXISTS aptran;
CREATE TABLE aptran (
    t_no DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_cust VARCHAR(16) NULL,
    t_dept VARCHAR(8) NULL,
    t_item VARCHAR(8) NULL,
    t_refno VARCHAR(20) NULL,
    t_par VARCHAR(255) NULL,
    t_amt DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_famt DECIMAL(16,2) NULL,
    t_rate DECIMAL(16,6) NULL,
    t_begdate DATETIME NULL,
    t_enddate DATETIME NULL,
    t_manl VARCHAR(8) NULL,
    t_writeoff VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_void VARCHAR(1) NULL,
    t_amtall DECIMAL(16,2) NULL,
    t_disrate DECIMAL(16,4) NULL,
    t_disamt DECIMAL(16,2) NULL,
    t_Checkno VARCHAR(16) NULL,
    t_taxrate DECIMAL(16,4) NULL,
    t_taxamt DECIMAL(16,4) NULL,
    t_paytype VARCHAR(1) NULL,
    t_Ispay VARCHAR(1) NULL,
    t_bankNo VARCHAR(8) NULL,
    t_Createtype VARCHAR(8) NULL,
    t_IsPrn VARCHAR(1) NULL,
    t_billamt DECIMAL(16,2) NULL,
    t_otheramt DECIMAL(16,2) NULL,
    PRIMARY KEY (t_no)
) ENGINE=InnoDB;

CREATE INDEX IX_aptran_cust ON aptran (t_cust);

-- 表: apitem
DROP TABLE IF EXISTS apitem;
CREATE TABLE apitem (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    enam VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    status VARCHAR(1) NULL,
    a_no VARCHAR(20) NULL,
    f_no VARCHAR(8) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: apcurr
DROP TABLE IF EXISTS apcurr;
CREATE TABLE apcurr (
    code VARCHAR(4) NOT NULL,
    name VARCHAR(10) NOT NULL,
    ename VARCHAR(20) NULL,
    xrate DECIMAL(10,6) NULL,
    begdt DATETIME NULL,
    enddt DATETIME NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Accidents
DROP TABLE IF EXISTS Accidents;
CREATE TABLE Accidents (
    AccidNo VARCHAR(8) NOT NULL,
    Class VARCHAR(8) NOT NULL,
    StartDate DATETIME NULL,
    EquipNo VARCHAR(20) NULL,
    Levels VARCHAR(8) NULL,
    Descript VARCHAR(255) NULL,
    Spoilage VARCHAR(80) NULL,
    Reason VARCHAR(8) NULL,
    Validation VARCHAR(80) NULL,
    Solution VARCHAR(80) NULL,
    DownTime DECIMAL(8,2) NULL,
    Lost DECIMAL(16,2) NULL,
    Cost DECIMAL(16,2) NULL,
    FinishDate DATETIME NULL,
    DutyMan VARCHAR(8) NULL,
    Prevent VARCHAR(80) NULL,
    Notes VARCHAR(40) NULL,
    Status VARCHAR(8) NULL,
    Flag VARCHAR(1) NULL,
    WOno VARCHAR(8) NULL,
    EntryBy VARCHAR(8) NULL,
    PRIMARY KEY (AccidNo)
) ENGINE=InnoDB;

-- 表: acc
DROP TABLE IF EXISTS acc;
CREATE TABLE acc (
    a_no VARCHAR(16) NOT NULL,
    a_name VARCHAR(80) NULL,
    a_a VARCHAR(1) NULL,
    a_b VARCHAR(1) NULL,
    a_c VARCHAR(1) NULL,
    a_d VARCHAR(1) NULL,
    a_e VARCHAR(1) NULL,
    a_f VARCHAR(1) NULL,
    a_g VARCHAR(1) NULL,
    a_h VARCHAR(1) NULL,
    a_unit VARCHAR(8) NULL,
    a_fx VARCHAR(8) NULL,
    a_cust VARCHAR(255) NULL,
    a_memo VARCHAR(50) NULL,
    a_flag VARCHAR(1) NULL,
    a_property1 VARCHAR(10) NULL,
    a_property2 VARCHAR(10) NULL,
    a_property3 VARCHAR(10) NULL,
    a_status VARCHAR(1) NULL,
    PRIMARY KEY (a_no)
) ENGINE=InnoDB;

-- 表: Fccard_Dpprice
DROP TABLE IF EXISTS Fccard_Dpprice;
CREATE TABLE Fccard_Dpprice (
    CardId INT NOT NULL,
    PriceDate DATETIME NOT NULL,
    DpPrice DECIMAL(19,4) NULL,
    StdMat DECIMAL(16,4) NULL,
    PRIMARY KEY (CardId, PriceDate)
) ENGINE=InnoDB;

-- 表: fccard
DROP TABLE IF EXISTS fccard;
CREATE TABLE fccard (
    cardid INT NOT NULL AUTO_INCREMENT,
    dpid INT NULL,
    isvalid VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    dishcode VARCHAR(8) NULL,
    dishname VARCHAR(30) NULL,
    dishename VARCHAR(120) NULL,
    itemname VARCHAR(30) NULL,
    dishunit VARCHAR(6) NULL,
    dspname VARCHAR(30) NULL,
    saleflag VARCHAR(1) NULL,
    DishChar VARCHAR(200) NULL,
    DishCooking VARCHAR(200) NULL,
    DishRemarks VARCHAR(60) NULL,
    PRIMARY KEY (cardid)
) ENGINE=InnoDB;

-- 表: fcbudget
DROP TABLE IF EXISTS fcbudget;
CREATE TABLE fcbudget (
    cline INT NOT NULL AUTO_INCREMENT,
    fcprd VARCHAR(8) NOT NULL,
    DeptCode VARCHAR(8) NOT NULL,
    fcitem VARCHAR(8) NOT NULL,
    acctypeid INT NULL,
    inamt DECIMAL(12,2) NULL,
    csamt DECIMAL(12,2) NULL,
    type VARCHAR(1) NOT NULL,
    memo VARCHAR(255) NULL,
    Flag VARCHAR(50) NOT NULL,
    PRIMARY KEY (cline)
) ENGINE=InnoDB;

-- 表: Family
DROP TABLE IF EXISTS Family;
CREATE TABLE Family (
    emID INT NOT NULL,
    faName VARCHAR(12) NULL,
    faRelation VARCHAR(12) NULL,
    faBirthday DATETIME NULL,
    faCompany VARCHAR(32) NULL,
    faPosition VARCHAR(16) NULL,
    faStand VARCHAR(16) NULL,
    faPhone VARCHAR(16) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: Events
DROP TABLE IF EXISTS Events;
CREATE TABLE Events (
    EventNo VARCHAR(8) NOT NULL,
    VarType VARCHAR(8) NULL,
    EquipNo VARCHAR(20) NULL,
    StartDate DATETIME NULL,
    FinishDate DATETIME NULL,
    OldDept VARCHAR(8) NULL,
    NewDept VARCHAR(8) NULL,
    OldLocation VARCHAR(8) NULL,
    NewLocation VARCHAR(8) NULL,
    Descript VARCHAR(80) NULL,
    Reason VARCHAR(80) NULL,
    Solution VARCHAR(80) NULL,
    Amount DECIMAL(16,2) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    OldItem VARCHAR(20) NULL,
    NewItem VARCHAR(20) NULL,
    Operator VARCHAR(8) NULL,
    PRIMARY KEY (EventNo)
) ENGINE=InnoDB;

-- 表: etti
DROP TABLE IF EXISTS etti;
CREATE TABLE etti (
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_acc VARCHAR(16) NOT NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_review VARCHAR(1) NOT NULL,
    t_post VARCHAR(1) NOT NULL,
    t_property INT NULL
) ENGINE=InnoDB;

-- 表: ett
DROP TABLE IF EXISTS ett;
CREATE TABLE ett (
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_acc VARCHAR(16) NOT NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_review VARCHAR(1) NOT NULL,
    t_post VARCHAR(1) NOT NULL,
    PRIMARY KEY (t_ym, t_class, t_no)
) ENGINE=InnoDB;

-- 表: EShift
DROP TABLE IF EXISTS EShift;
CREATE TABLE EShift (
    code VARCHAR(8) NOT NULL,
    startdate DATETIME NULL,
    finishdate DATETIME NULL,
    starttime DECIMAL(4,0) NULL,
    finishtime DECIMAL(4,0) NULL,
    manhours DECIMAL(8,2) NULL,
    shift VARCHAR(8) NULL,
    craft VARCHAR(8) NULL,
    empl VARCHAR(8) NULL,
    notes VARCHAR(40) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: EServices
DROP TABLE IF EXISTS EServices;
CREATE TABLE EServices (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Spec VARCHAR(80) NULL,
    Cycle VARCHAR(8) NULL,
    ManHours DECIMAL(8,2) NULL,
    Parts DECIMAL(16,2) NULL,
    LastDate DATETIME NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    Support VARCHAR(20) NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: ESafety
DROP TABLE IF EXISTS ESafety;
CREATE TABLE ESafety (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: equsage
DROP TABLE IF EXISTS equsage;
CREATE TABLE equsage (
    eqcost VARCHAR(8) NOT NULL,
    eqdept VARCHAR(8) NOT NULL,
    eqtype VARCHAR(8) NOT NULL,
    a_no VARCHAR(16) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    dflt VARCHAR(1) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (eqcost, eqdept, eqtype)
) ENGINE=InnoDB;

-- 表: Equipments
DROP TABLE IF EXISTS Equipments;
CREATE TABLE Equipments (
    EquipNo VARCHAR(20) NOT NULL,
    Name VARCHAR(40) NULL,
    Model VARCHAR(20) NULL,
    Unit VARCHAR(8) NULL,
    Category VARCHAR(8) NULL,
    Location VARCHAR(8) NULL,
    Department VARCHAR(8) NULL,
    KeepBy VARCHAR(8) NULL,
    Purpose VARCHAR(8) NULL,
    Country VARCHAR(8) NULL,
    Factory VARCHAR(8) NULL,
    Vendor VARCHAR(8) NULL,
    FactoryNo VARCHAR(20) NULL,
    FactoryDate DATETIME NULL,
    PurchaseDate DATETIME NULL,
    SetupDate DATETIME NULL,
    StartDate DATETIME NULL,
    UsefulLife DECIMAL(8,0) NULL,
    WarrantyDate DATETIME NULL,
    ContractNo VARCHAR(20) NULL,
    ServiceCycle VARCHAR(8) NULL,
    Priority DECIMAL(8,2) NULL,
    TechLevel VARCHAR(8) NULL,
    Complex DECIMAL(8,2) NULL,
    SpareModel VARCHAR(20) NULL,
    Status VARCHAR(8) NULL,
    Barcode VARCHAR(20) NULL,
    Special VARCHAR(8) NULL,
    Picture VARCHAR(30) NULL,
    EntryDate DATETIME NULL,
    EntryBy VARCHAR(8) NULL,
    Notes VARCHAR(30) NULL,
    Flag VARCHAR(1) NULL,
    AssetNo VARCHAR(20) NULL,
    Class VARCHAR(8) NULL,
    ABC VARCHAR(1) NULL,
    AddReason VARCHAR(8) NULL,
    FinishDate DATETIME NULL,
    SubReason VARCHAR(8) NULL,
    OriginalVal DECIMAL(16,2) NULL,
    SalvageVal DECIMAL(16,2) NULL,
    CleanFee DECIMAL(16,2) NULL,
    DeprMethod VARCHAR(8) NULL,
    DeprLife DECIMAL(8,0) NULL,
    DeprRate DECIMAL(8,4) NULL,
    DeprCoef DECIMAL(8,2) NULL,
    DeprMonth DECIMAL(16,2) NULL,
    DeprTotal DECIMAL(16,2) NULL,
    NetVal DECIMAL(16,2) NULL,
    DeprDate DATETIME NULL,
    WorkMonth DECIMAL(16,2) NULL,
    WorkTotal DECIMAL(16,2) NULL,
    Quantity DECIMAL(8,0) NULL,
    ItemNo VARCHAR(20) NULL,
    DeprYear DECIMAL(16,2) NULL,
    wage DECIMAL(10,4) NULL,
    capacity DECIMAL(10,4) NULL,
    e_elec VARCHAR(20) NULL,
    e_model VARCHAR(20) NULL,
    e_power DECIMAL(10,4) NULL,
    e_elvo DECIMAL(10,4) NULL,
    e_elcu DECIMAL(10,4) NULL,
    e_soon DECIMAL(10,4) NULL,
    e_connet VARCHAR(20) NULL,
    e_frmodel VARCHAR(20) NULL,
    e_bmodel VARCHAR(20) NULL,
    e_lnmodel VARCHAR(20) NULL,
    e_wage DECIMAL(10,4) NULL,
    e_checkdate DATETIME NULL,
    e_factory VARCHAR(30) NULL,
    e_factorydate DATETIME NULL,
    e_factoryout VARCHAR(10) NULL,
    RecordNo VARCHAR(20) NULL,
    Size VARCHAR(20) NULL,
    salvagevalueRate DECIMAL(10,4) NULL,
    Buildertype VARCHAR(1) NULL,
    AccountStatus VARCHAR(1) NULL,
    deprcount INT NULL,
    deprbymonth DECIMAL(16,2) NULL,
    PRIMARY KEY (EquipNo)
) ENGINE=InnoDB;

-- 表: eqdepr
DROP TABLE IF EXISTS eqdepr;
CREATE TABLE eqdepr (
    class VARCHAR(8) NOT NULL,
    a_no VARCHAR(16) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (class)
) ENGINE=InnoDB;

-- 表: EParameters
DROP TABLE IF EXISTS EParameters;
CREATE TABLE EParameters (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Scope VARCHAR(20) NULL,
    Unit VARCHAR(8) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: enti
DROP TABLE IF EXISTS enti;
CREATE TABLE enti (
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_line DECIMAL(4,0) NOT NULL,
    t_type VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_review VARCHAR(1) NULL,
    t_acc VARCHAR(16) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_pr DECIMAL(16,4) NOT NULL,
    t_drn DECIMAL(16,4) NOT NULL,
    t_crn DECIMAL(16,4) NOT NULL,
    t_fr DECIMAL(16,4) NOT NULL,
    t_drf DECIMAL(16,2) NOT NULL,
    t_crf DECIMAL(16,2) NOT NULL,
    t_meth VARCHAR(8) NULL,
    t_rdat DATETIME NULL,
    t_ref VARCHAR(8) NULL,
    t_flag VARCHAR(1) NULL,
    t_xacc VARCHAR(16) NULL,
    t_cust VARCHAR(16) NULL,
    t_cfno VARCHAR(8) NULL,
    t_cust1 VARCHAR(16) NULL,
    t_cust2 VARCHAR(16) NULL,
    t_cust3 VARCHAR(16) NULL,
    t_cust4 VARCHAR(16) NULL,
    t_cust5 VARCHAR(16) NULL,
    t_cust6 VARCHAR(16) NULL,
    t_cust7 VARCHAR(16) NULL,
    t_cust8 VARCHAR(16) NULL,
    t_cust9 VARCHAR(16) NULL,
    PRIMARY KEY (t_ym, t_class, t_no, t_line)
) ENGINE=InnoDB;

CREATE INDEX index_enti_t_acc ON enti (t_acc);
CREATE INDEX index_enti_t_date ON enti (t_date);

-- 表: entgi
DROP TABLE IF EXISTS entgi;
CREATE TABLE entgi (
    s_no VARCHAR(8) NOT NULL,
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_line DECIMAL(4,0) NOT NULL,
    t_type VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_review VARCHAR(1) NULL,
    t_acc VARCHAR(16) NULL,
    t_par VARCHAR(30) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_pr DECIMAL(16,4) NOT NULL,
    t_drn DECIMAL(16,4) NOT NULL,
    t_crn DECIMAL(16,4) NOT NULL,
    t_fr DECIMAL(16,4) NOT NULL,
    t_drf DECIMAL(16,2) NOT NULL,
    t_crf DECIMAL(16,2) NOT NULL,
    t_meth VARCHAR(8) NULL,
    t_rdat DATETIME NULL,
    t_ref VARCHAR(8) NULL,
    t_flag VARCHAR(1) NULL,
    t_xacc VARCHAR(16) NULL,
    t_cust VARCHAR(16) NULL,
    t_cfno VARCHAR(8) NULL,
    t_drx VARCHAR(80) NULL,
    t_crx VARCHAR(80) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    PRIMARY KEY (s_no, t_line)
) ENGINE=InnoDB;

-- 表: entg
DROP TABLE IF EXISTS entg;
CREATE TABLE entg (
    s_no VARCHAR(8) NOT NULL,
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_ap DECIMAL(4,0) NOT NULL,
    t_type VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_review VARCHAR(1) NULL,
    t_acc VARCHAR(16) NULL,
    t_par VARCHAR(30) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_drn DECIMAL(16,4) NOT NULL,
    t_crn DECIMAL(16,4) NOT NULL,
    t_drf DECIMAL(16,2) NOT NULL,
    t_crf DECIMAL(16,2) NOT NULL,
    t_man1 VARCHAR(8) NULL,
    t_man2 VARCHAR(8) NULL,
    t_man3 VARCHAR(8) NULL,
    t_man4 VARCHAR(8) NULL,
    t_man5 VARCHAR(8) NULL,
    t_cotype VARCHAR(1) NULL DEFAULT '0',
    t_inacc VARCHAR(50) NULL,
    t_outacc VARCHAR(255) NULL,
    PRIMARY KEY (s_no)
) ENGINE=InnoDB;

-- 表: ent
DROP TABLE IF EXISTS ent;
CREATE TABLE ent (
    t_ym VARCHAR(7) NOT NULL,
    t_date DATETIME NOT NULL,
    t_class VARCHAR(4) NOT NULL,
    t_no DECIMAL(4,0) NOT NULL,
    t_gno DECIMAL(4,0) NOT NULL,
    t_ap DECIMAL(4,0) NOT NULL,
    t_type VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_review VARCHAR(1) NULL,
    t_acc VARCHAR(16) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NOT NULL,
    t_cr DECIMAL(16,2) NOT NULL,
    t_drn DECIMAL(16,4) NOT NULL,
    t_crn DECIMAL(16,4) NOT NULL,
    t_drf DECIMAL(16,2) NOT NULL,
    t_crf DECIMAL(16,2) NOT NULL,
    t_man1 VARCHAR(8) NULL,
    t_man2 VARCHAR(8) NULL,
    t_man3 VARCHAR(8) NULL,
    t_man4 VARCHAR(8) NULL,
    t_man5 VARCHAR(8) NULL,
    autogen VARCHAR(1) NULL,
    wsfile VARCHAR(8) NULL,
    PRIMARY KEY (t_ym, t_class, t_no)
) ENGINE=InnoDB;

-- 表: EnergyRecs
DROP TABLE IF EXISTS EnergyRecs;
CREATE TABLE EnergyRecs (
    EntNo VARCHAR(8) NOT NULL,
    EntDate DATETIME NULL,
    EquipNo VARCHAR(20) NULL,
    Department VARCHAR(8) NULL,
    Energy VARCHAR(8) NULL,
    Meter VARCHAR(8) NULL,
    StartDate DATETIME NULL,
    StartVal DECIMAL(12,3) NULL,
    FinishDate DATETIME NULL,
    FinishVal DECIMAL(12,3) NULL,
    Ajustment DECIMAL(12,3) NULL,
    Quantity DECIMAL(12,3) NULL,
    Price DECIMAL(16,2) NULL,
    Amount DECIMAL(16,2) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Material VARCHAR(8) NULL,
    PRIMARY KEY (EntNo)
) ENGINE=InnoDB;

-- 表: EnergyMeters
DROP TABLE IF EXISTS EnergyMeters;
CREATE TABLE EnergyMeters (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(30) NULL,
    Class VARCHAR(8) NULL,
    Unit VARCHAR(8) NULL,
    mutiple DECIMAL(8,3) NULL,
    FinishVal DECIMAL(12,3) NULL,
    FinishDate DATETIME NULL,
    Location VARCHAR(8) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: emxl
DROP TABLE IF EXISTS emxl;
CREATE TABLE emxl (
    emid INT NOT NULL,
    FsortId INT NOT NULL,
    emxl VARCHAR(20) NULL,
    FinshSchool VARCHAR(80) NULL,
    Fbegindate VARCHAR(16) NULL,
    Fenddate VARCHAR(16) NULL,
    PRIMARY KEY (emid, FsortId)
) ENGINE=InnoDB;

-- 表: EmployeeHistory
DROP TABLE IF EXISTS EmployeeHistory;
CREATE TABLE EmployeeHistory (
    emDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    emID INT NOT NULL,
    emCode VARCHAR(8) NOT NULL,
    dtCode VARCHAR(12) NULL,
    emName VARCHAR(16) NOT NULL,
    emSex VARCHAR(2) NULL,
    emPassID VARCHAR(18) NULL,
    emName2 VARCHAR(16) NULL,
    emEName VARCHAR(16) NULL,
    emBirthday DATETIME NULL,
    emCardNo VARCHAR(24) NULL,
    emSocialNo VARCHAR(30) NULL,
    emAgeNo VARCHAR(30) NULL,
    emBankNo VARCHAR(30) NULL,
    emNation VARCHAR(8) NULL,
    emNative VARCHAR(16) NULL,
    emHomeplace VARCHAR(32) NULL,
    emMarriage VARCHAR(8) NULL,
    emStatus VARCHAR(16) NULL,
    emAge INT NULL,
    emEducation VARCHAR(16) NULL,
    emSchool VARCHAR(32) NULL,
    emSpeciality VARCHAR(64) NULL,
    emDegree VARCHAR(8) NULL,
    emFL VARCHAR(10) NULL,
    emFLClass VARCHAR(20) NULL,
    emStand VARCHAR(16) NULL,
    emWorkTime DATETIME NULL,
    emHireTime DATETIME NULL,
    emWorkLength INT NULL,
    emHireLength INT NULL,
    emPersonKind VARCHAR(16) NULL,
    emWorkType VARCHAR(24) NULL,
    emTDuty VARCHAR(24) NULL,
    emADuty VARCHAR(24) NULL,
    emWageClass VARCHAR(24) NULL,
    emAddress VARCHAR(120) NULL,
    emPostCode VARCHAR(6) NULL,
    emPhone VARCHAR(30) NULL,
    emRPRAddress VARCHAR(48) NULL,
    emRPRType VARCHAR(16) NULL,
    emFFamily VARCHAR(16) NULL,
    emOutState VARCHAR(16) NULL,
    emOutTime DATETIME NULL,
    emOffState VARCHAR(16) NULL,
    emOffTime DATETIME NULL,
    ptCode VARCHAR(8) NOT NULL,
    emSkill VARCHAR(32) NULL,
    emInterest VARCHAR(32) NULL,
    emPhoto VARCHAR(128) NULL,
    emStature INT NULL,
    emWeight DECIMAL(10,1) NULL,
    emEyesight DECIMAL(10,1) NULL,
    emMobile VARCHAR(16) NULL,
    emMemo VARCHAR(255) NULL,
    emField1 VARCHAR(255) NULL,
    emField2 VARCHAR(255) NULL,
    emField3 VARCHAR(255) NULL,
    emField4 VARCHAR(255) NULL,
    emField5 VARCHAR(255) NULL,
    emField6 VARCHAR(255) NULL,
    emField7 VARCHAR(255) NULL,
    emField8 VARCHAR(255) NULL,
    emField9 VARCHAR(255) NULL,
    emField10 VARCHAR(255) NULL,
    accattr VARCHAR(8) NULL,
    Standardwage DECIMAL(19,4) NULL,
    Healthpaperenddate DATETIME NULL,
    Pannedenddate DATETIME NULL,
    Idleenddate DATETIME NULL,
    Finsuredate DATETIME NULL,
    Finsurewage DECIMAL(19,4) NULL,
    medicareAcc VARCHAR(30) NULL,
    embankNo2 VARCHAR(30) NULL,
    embankNo3 VARCHAR(30) NULL,
    cemclassday VARCHAR(10) NULL,
    PRIMARY KEY (emDate, emID)
) ENGINE=InnoDB;

CREATE INDEX IDX_EmployeeHistory ON EmployeeHistory (emCode);

-- 表: Employee_eqp
DROP TABLE IF EXISTS Employee_eqp;
CREATE TABLE Employee_eqp (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(8) NULL,
    Class VARCHAR(8) NULL,
    Gender VARCHAR(2) NULL,
    Birthdate DATETIME NULL,
    Education VARCHAR(8) NULL,
    Title VARCHAR(8) NULL,
    Address VARCHAR(60) NULL,
    Zip VARCHAR(8) NULL,
    Tel VARCHAR(20) NULL,
    WorkNo VARCHAR(8) NULL,
    ArrDate DATETIME NULL,
    Craft VARCHAR(8) NULL,
    Crew VARCHAR(8) NULL,
    Duty VARCHAR(8) NULL,
    HoursFee DECIMAL(10,2) NULL,
    Picture VARCHAR(30) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    status VARCHAR(8) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: Employee
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    emID INT NOT NULL AUTO_INCREMENT,
    emCode VARCHAR(8) NOT NULL,
    dtCode VARCHAR(12) NULL,
    emName VARCHAR(16) NOT NULL,
    emSex VARCHAR(2) NULL,
    emPassID VARCHAR(18) NULL,
    emName2 VARCHAR(16) NULL,
    emEName VARCHAR(16) NULL,
    emBirthday DATETIME NULL,
    emCardNo VARCHAR(24) NULL,
    emSocialNo VARCHAR(30) NULL,
    emAgeNo VARCHAR(30) NULL,
    emBankNo VARCHAR(30) NULL,
    emNation VARCHAR(8) NULL,
    emNative VARCHAR(16) NULL,
    emHomeplace VARCHAR(32) NULL,
    emMarriage VARCHAR(8) NULL,
    emStatus VARCHAR(16) NULL,
    emAge INT NULL,
    emEducation VARCHAR(16) NULL,
    emSchool VARCHAR(32) NULL,
    emSpeciality VARCHAR(64) NULL,
    emDegree VARCHAR(8) NULL,
    emFL VARCHAR(10) NULL,
    emFLClass VARCHAR(20) NULL,
    emStand VARCHAR(16) NULL,
    emWorkTime DATETIME NULL,
    emHireTime DATETIME NULL,
    emWorkLength INT NULL,
    emHireLength INT NULL,
    emPersonKind VARCHAR(16) NULL,
    emWorkType VARCHAR(24) NULL,
    emTDuty VARCHAR(24) NULL,
    emADuty VARCHAR(24) NULL,
    emWageClass VARCHAR(24) NULL,
    emAddress VARCHAR(120) NULL,
    emPostCode VARCHAR(6) NULL,
    emPhone VARCHAR(30) NULL,
    emRPRAddress VARCHAR(48) NULL,
    emRPRType VARCHAR(16) NULL,
    emFFamily VARCHAR(16) NULL,
    emOutState VARCHAR(16) NULL,
    emOutTime DATETIME NULL,
    emOffState VARCHAR(16) NULL,
    emOffTime DATETIME NULL,
    ptCode VARCHAR(8) NOT NULL,
    emSkill VARCHAR(32) NULL,
    emInterest VARCHAR(32) NULL,
    emPhoto VARCHAR(128) NULL,
    emStature INT NULL,
    emWeight DECIMAL(10,1) NULL,
    emEyesight DECIMAL(10,1) NULL,
    emMobile VARCHAR(16) NULL,
    emMemo VARCHAR(255) NULL,
    emField1 VARCHAR(255) NULL,
    emField2 VARCHAR(255) NULL,
    emField3 VARCHAR(255) NULL,
    emField4 VARCHAR(255) NULL,
    emField5 VARCHAR(255) NULL,
    emField6 VARCHAR(255) NULL,
    emField7 VARCHAR(255) NULL,
    emField8 VARCHAR(255) NULL,
    emField9 VARCHAR(255) NULL,
    emField10 VARCHAR(255) NULL,
    accattr VARCHAR(8) NULL,
    Standardwage DECIMAL(19,4) NULL,
    Healthpaperenddate DATETIME NULL,
    Pannedenddate DATETIME NULL,
    Idleenddate DATETIME NULL,
    Finsuredate DATETIME NULL,
    Finsurewage DECIMAL(19,4) NULL,
    medicareAcc VARCHAR(30) NULL,
    embankNo2 VARCHAR(30) NULL,
    embankNo3 VARCHAR(30) NULL,
    cemclassday VARCHAR(10) NULL,
    Departuredate DATETIME NULL,
    PRIMARY KEY (emID)
) ENGINE=InnoDB;

-- 表: EMeters
DROP TABLE IF EXISTS EMeters;
CREATE TABLE EMeters (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Model VARCHAR(20) NULL,
    Class VARCHAR(8) NULL,
    Unit VARCHAR(8) NULL,
    Reading DECIMAL(12,3) NULL,
    RegDate DATETIME NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: ELedger
DROP TABLE IF EXISTS ELedger;
CREATE TABLE ELedger (
    EquipNo VARCHAR(20) NOT NULL,
    T_date DATETIME NOT NULL,
    T_class VARCHAR(8) NOT NULL,
    T_no DECIMAL(8,0) NOT NULL,
    T_par VARCHAR(30) NULL,
    T_acc VARCHAR(20) NULL,
    T_dr DECIMAL(16,2) NULL,
    T_cr DECIMAL(16,2) NULL,
    T_flag VARCHAR(1) NULL,
    Sno VARCHAR(5) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: Education
DROP TABLE IF EXISTS Education;
CREATE TABLE Education (
    emID INT NOT NULL,
    edMethod VARCHAR(24) NOT NULL,
    edBegin DATETIME NULL,
    edEnd DATETIME NULL,
    edPeriod VARCHAR(12) NULL,
    edSpec VARCHAR(12) NULL,
    edCompany VARCHAR(32) NULL,
    edContent VARCHAR(32) NULL,
    edOutlay DECIMAL(19,4) NULL,
    edResult VARCHAR(32) NULL,
    RecNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: EDocuments
DROP TABLE IF EXISTS EDocuments;
CREATE TABLE EDocuments (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Class VARCHAR(8) NULL,
    Quantity DECIMAL(8,0) NULL,
    DocuFile VARCHAR(30) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: ecl
DROP TABLE IF EXISTS ecl;
CREATE TABLE ecl (
    c_type VARCHAR(1) NOT NULL,
    c_clas VARCHAR(4) NOT NULL,
    c_form VARCHAR(4) NOT NULL,
    c_unit VARCHAR(8) NULL,
    c_fx VARCHAR(8) NULL,
    c_dracc VARCHAR(16) NULL,
    c_cracc VARCHAR(16) NULL,
    c_memo VARCHAR(30) NULL,
    PRIMARY KEY (c_type)
) ENGINE=InnoDB;

-- 表: EAccessories
DROP TABLE IF EXISTS EAccessories;
CREATE TABLE EAccessories (
    EquipNo VARCHAR(20) NOT NULL,
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    Model VARCHAR(20) NULL,
    Class VARCHAR(8) NULL,
    Unit VARCHAR(8) NULL,
    Quantity DECIMAL(8,0) NULL,
    Price DECIMAL(16,2) NULL,
    Amount DECIMAL(16,2) NULL,
    Factory VARCHAR(8) NULL,
    SpareModel VARCHAR(20) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    Sno DECIMAL(8,0) NOT NULL,
    PRIMARY KEY (EquipNo, Sno)
) ENGINE=InnoDB;

-- 表: Dept
DROP TABLE IF EXISTS Dept;
CREATE TABLE Dept (
    dtCode VARCHAR(12) NOT NULL,
    dtName VARCHAR(24) NULL,
    dtPCode VARCHAR(12) NULL,
    dtMemo VARCHAR(32) NULL,
    PRIMARY KEY (dtCode)
) ENGINE=InnoDB;

-- 表: dbupdatetime
DROP TABLE IF EXISTS dbupdatetime;
CREATE TABLE dbupdatetime (
    code VARCHAR(10) NOT NULL,
    name VARCHAR(30) NULL,
    notes VARCHAR(255) NULL
) ENGINE=InnoDB;

-- 表: custsigner
DROP TABLE IF EXISTS custsigner;
CREATE TABLE custsigner (
    CustID VARCHAR(16) NOT NULL,
    SignID VARCHAR(8) NOT NULL,
    Memo VARCHAR(30) NULL,
    Flag VARCHAR(1) NULL,
    PRIMARY KEY (CustID, SignID)
) ENGINE=InnoDB;

-- 表: cust
DROP TABLE IF EXISTS cust;
CREATE TABLE cust (
    c_code VARCHAR(16) NOT NULL,
    c_name VARCHAR(80) NULL,
    c_clas VARCHAR(16) NOT NULL,
    c_memo VARCHAR(30) NULL,
    c_flag VARCHAR(1) NULL,
    c_dscr VARCHAR(200) NULL,
    c_levels VARCHAR(1) NULL,
    c_isdtl VARCHAR(1) NULL,
    c_status VARCHAR(1) NULL,
    c_abbr VARCHAR(30) NULL,
    c_category VARCHAR(8) NULL DEFAULT '',
    c_bankname VARCHAR(30) NULL,
    c_bankacc VARCHAR(30) NULL,
    c_taxid VARCHAR(30) NULL,
    c_address VARCHAR(100) NULL,
    c_zipcode VARCHAR(6) NULL,
    c_tel VARCHAR(100) NULL,
    c_fax VARCHAR(20) NULL,
    c_email VARCHAR(30) NULL,
    c_contact VARCHAR(30) NULL,
    c_signers VARCHAR(100) NULL,
    c_credit DECIMAL(16,2) NULL,
    c_begdt DATETIME NULL,
    c_enddt DATETIME NULL,
    c_accno VARCHAR(16) NULL,
    c_bal DECIMAL(16,2) NULL,
    c_interval VARCHAR(8) NULL,
    c_discount VARCHAR(8) NULL,
    c_modpsn VARCHAR(8) NULL,
    c_custtype VARCHAR(1) NULL,
    c_photo VARCHAR(30) NULL,
    FisCreditCard VARCHAR(50) NULL,
    c_address1 VARCHAR(100) NULL,
    c_address2 VARCHAR(100) NULL,
    c_address3 VARCHAR(100) NULL,
    c_preaccno VARCHAR(16) NULL,
    c_tax VARCHAR(1) NULL,
    pym VARCHAR(50) NULL,
    PRIMARY KEY (c_code, c_clas)
) ENGINE=InnoDB;

CREATE INDEX id_cust_c_clas ON cust (c_clas);

-- 表: Country
DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
    CountryCode VARCHAR(4) NOT NULL,
    Country VARCHAR(30) NOT NULL,
    EnglishCountry VARCHAR(30) NOT NULL,
    PRIMARY KEY (CountryCode)
) ENGINE=InnoDB;

-- 表: Codes_gl
DROP TABLE IF EXISTS Codes_gl;
CREATE TABLE Codes_gl (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(20) NULL,
    value INT NOT NULL,
    remarks VARCHAR(50) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Codes_eqp
DROP TABLE IF EXISTS Codes_eqp;
CREATE TABLE Codes_eqp (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(20) NULL,
    class VARCHAR(8) NULL,
    notes VARCHAR(255) NULL,
    flag VARCHAR(1) NULL,
    value VARCHAR(20) NULL,
    a_no VARCHAR(16) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Codes_ars
DROP TABLE IF EXISTS Codes_ars;
CREATE TABLE Codes_ars (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(20) NULL,
    class VARCHAR(8) NULL,
    notes VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    value VARCHAR(20) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: Codes
DROP TABLE IF EXISTS Codes;
CREATE TABLE Codes (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(20) NULL,
    class VARCHAR(8) NULL,
    notes VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    value VARCHAR(20) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: chcki
DROP TABLE IF EXISTS chcki;
CREATE TABLE chcki (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no VARCHAR(8) NULL,
    t_xacc VARCHAR(16) NULL,
    t_cust VARCHAR(30) NULL,
    t_amt DECIMAL(16,2) NULL,
    t_par VARCHAR(30) NULL,
    t_memo VARCHAR(30) NULL,
    t_man1 VARCHAR(8) NULL,
    t_man2 VARCHAR(8) NULL,
    t_man3 VARCHAR(8) NULL,
    t_man4 VARCHAR(8) NULL,
    t_man5 VARCHAR(8) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: chck
DROP TABLE IF EXISTS chck;
CREATE TABLE chck (
    a_no VARCHAR(16) NOT NULL,
    a_name VARCHAR(80) NULL,
    a_bank VARCHAR(30) NULL,
    a_bkno VARCHAR(30) NULL,
    PRIMARY KEY (a_no)
) ENGINE=InnoDB;

-- 表: cfno
DROP TABLE IF EXISTS cfno;
CREATE TABLE cfno (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(60) NULL,
    line VARCHAR(8) NULL,
    memo VARCHAR(80) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: cashi
DROP TABLE IF EXISTS cashi;
CREATE TABLE cashi (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no DECIMAL(4,0) NULL,
    t_xacc VARCHAR(16) NULL,
    t_ref VARCHAR(8) NULL,
    t_par VARCHAR(30) NULL,
    t_dr DECIMAL(16,2) NULL,
    t_cr DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_flag VARCHAR(1) NULL,
    t_man1 VARCHAR(8) NULL,
    t_man2 VARCHAR(8) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: cash
DROP TABLE IF EXISTS cash;
CREATE TABLE cash (
    a_no VARCHAR(16) NOT NULL,
    a_name VARCHAR(100) NULL,
    a_bal DECIMAL(16,2) NULL,
    PRIMARY KEY (a_no)
) ENGINE=InnoDB;

-- 表: CardDisrate
DROP TABLE IF EXISTS CardDisrate;
CREATE TABLE CardDisrate (
    code INT NOT NULL AUTO_INCREMENT,
    FcustNo VARCHAR(16) NOT NULL,
    FCardNo VARCHAR(8) NOT NULL,
    FDisrate DECIMAL(6,4) NOT NULL DEFAULT 0,
    FDecDigits INT NOT NULL DEFAULT 0,
    Fmemo VARCHAR(255) NULL,
    PRIMARY KEY (FcustNo, FCardNo)
) ENGINE=InnoDB;

-- 表: Cal
DROP TABLE IF EXISTS Cal;
CREATE TABLE Cal (
    RecNo INT NOT NULL,
    Title VARCHAR(128) NULL,
    BeginTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    IsDateEvent TINYINT(1) NOT NULL,
    EventType SMALLINT NOT NULL,
    IsAwake TINYINT(1) NOT NULL,
    AwakeTime INT NOT NULL,
    AwakeText VARCHAR(250) NULL,
    Owner VARCHAR(8) NOT NULL,
    IsPrivate TINYINT(1) NOT NULL,
    ToUser VARCHAR(250) NULL,
    Memo VARCHAR(250) NULL,
    PRIMARY KEY (RecNo)
) ENGINE=InnoDB;

-- 表: bRptParam
DROP TABLE IF EXISTS bRptParam;
CREATE TABLE bRptParam (
    Code VARCHAR(150) NOT NULL,
    CName VARCHAR(150) NOT NULL,
    DataType INT NULL,
    CValue VARCHAR(150) NULL,
    SelCode VARCHAR(20) NULL,
    Remarks VARCHAR(150) NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: bRpt
DROP TABLE IF EXISTS bRpt;
CREATE TABLE bRpt (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(40) NULL,
    DataWindow VARCHAR(250) NULL,
    Notes VARCHAR(40) NULL,
    Flag VARCHAR(1) NULL,
    EName VARCHAR(40) NULL,
    Category VARCHAR(8) NULL,
    Remarks VARCHAR(255) NULL,
    Qryscope VARCHAR(255) NULL,
    DateModi VARCHAR(255) NULL,
    Copies INT NULL DEFAULT 1,
    Printer VARCHAR(255) NULL,
    rpttype INT NULL DEFAULT 0,
    tag INT NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: bCondition
DROP TABLE IF EXISTS bCondition;
CREATE TABLE bCondition (
    TableName VARCHAR(20) NOT NULL,
    Code VARCHAR(150) NOT NULL,
    Name VARCHAR(150) NULL,
    Relation VARCHAR(5) NULL,
    CValue VARCHAR(150) NULL,
    Logic VARCHAR(5) NULL,
    DataType INT NULL,
    IsBillDate TINYINT(1) NULL,
    Sequence INT NULL,
    ReportType INT NULL DEFAULT 0,
    SelCode VARCHAR(150) NULL,
    SerCon VARCHAR(150) NULL,
    ParamType INT NULL,
    PRIMARY KEY (TableName, Code)
) ENGINE=InnoDB;

-- 表: bbackup
DROP TABLE IF EXISTS bbackup;
CREATE TABLE bbackup (
    id INT NOT NULL,
    date DATETIME NOT NULL,
    name VARCHAR(100) NOT NULL,
    filename VARCHAR(255) NOT NULL,
    memo VARCHAR(255) NULL,
    usercode VARCHAR(8) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- 表: bargain
DROP TABLE IF EXISTS bargain;
CREATE TABLE bargain (
    emID INT NOT NULL,
    bgType VARCHAR(24) NOT NULL,
    bgBegdate DATETIME NULL,
    bgEnddate DATETIME NULL,
    bgMemo VARCHAR(32) NULL,
    recNo INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (recNo)
) ENGINE=InnoDB;

-- 表: banks
DROP TABLE IF EXISTS banks;
CREATE TABLE banks (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no DECIMAL(4,0) NULL,
    t_xacc VARCHAR(16) NULL,
    t_ref VARCHAR(8) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NULL,
    t_cr DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_flag VARCHAR(1) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: bankinfo
DROP TABLE IF EXISTS bankinfo;
CREATE TABLE bankinfo (
    Code VARCHAR(8) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    StartDate DATETIME NULL,
    Curcode VARCHAR(8) NULL,
    Sheet VARCHAR(50) NULL,
    Status VARCHAR(1) NULL,
    checknolen INT NULL,
    PRIMARY KEY (Code)
) ENGINE=InnoDB;

-- 表: banki
DROP TABLE IF EXISTS banki;
CREATE TABLE banki (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no DECIMAL(4,0) NULL,
    t_xacc VARCHAR(16) NULL,
    t_ref VARCHAR(8) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NULL,
    t_cr DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_flag VARCHAR(1) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: banke
DROP TABLE IF EXISTS banke;
CREATE TABLE banke (
    a_no VARCHAR(16) NOT NULL,
    t_line DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_no DECIMAL(4,0) NULL,
    t_xacc VARCHAR(16) NULL,
    t_ref VARCHAR(8) NULL,
    t_par VARCHAR(50) NULL,
    t_dr DECIMAL(16,2) NULL,
    t_cr DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_flag VARCHAR(1) NULL,
    PRIMARY KEY (a_no, t_line)
) ENGINE=InnoDB;

-- 表: bank
DROP TABLE IF EXISTS bank;
CREATE TABLE bank (
    a_no VARCHAR(16) NOT NULL,
    a_name VARCHAR(30) NULL,
    a_bank VARCHAR(30) NULL,
    a_bkno VARCHAR(30) NULL,
    a_bali DECIMAL(16,2) NULL,
    a_bals DECIMAL(16,2) NULL,
    PRIMARY KEY (a_no)
) ENGINE=InnoDB;

-- 表: balc
DROP TABLE IF EXISTS balc;
CREATE TABLE balc (
    a_yymm VARCHAR(7) NOT NULL,
    a_no VARCHAR(16) NOT NULL,
    a_cust1 VARCHAR(16) NOT NULL,
    a_cust2 VARCHAR(16) NOT NULL,
    a_cust3 VARCHAR(16) NOT NULL,
    a_cust4 VARCHAR(16) NOT NULL,
    a_cust5 VARCHAR(16) NOT NULL,
    a_cust6 VARCHAR(16) NOT NULL,
    a_cust7 VARCHAR(16) NOT NULL,
    a_cust8 VARCHAR(16) NOT NULL,
    a_cust9 VARCHAR(16) NOT NULL,
    a_dr1 DECIMAL(16,2) NOT NULL,
    a_cr1 DECIMAL(16,2) NOT NULL,
    a_bal1 DECIMAL(16,2) NOT NULL,
    a_dr2 DECIMAL(16,2) NOT NULL,
    a_cr2 DECIMAL(16,2) NOT NULL,
    a_drn1 DECIMAL(16,4) NOT NULL,
    a_crn1 DECIMAL(16,4) NOT NULL,
    a_baln1 DECIMAL(16,4) NOT NULL,
    a_drn2 DECIMAL(16,4) NOT NULL,
    a_crn2 DECIMAL(16,4) NOT NULL,
    a_drf1 DECIMAL(16,2) NOT NULL,
    a_crf1 DECIMAL(16,2) NOT NULL,
    a_balf1 DECIMAL(16,2) NOT NULL,
    a_drf2 DECIMAL(16,2) NOT NULL,
    a_crf2 DECIMAL(16,2) NOT NULL,
    a_est DECIMAL(16,2) NOT NULL,
    a_estn DECIMAL(16,4) NOT NULL,
    a_estf DECIMAL(16,2) NOT NULL,
    PRIMARY KEY (a_yymm, a_no, a_cust1, a_cust2, a_cust3, a_cust4, a_cust5, a_cust6, a_cust7, a_cust8, a_cust9)
) ENGINE=InnoDB;

-- 表: bal
DROP TABLE IF EXISTS bal;
CREATE TABLE bal (
    a_yymm VARCHAR(7) NOT NULL,
    a_no VARCHAR(16) NOT NULL,
    a_dr1 DECIMAL(16,2) NOT NULL,
    a_cr1 DECIMAL(16,2) NOT NULL,
    a_bal1 DECIMAL(16,2) NOT NULL,
    a_dr2 DECIMAL(16,2) NOT NULL,
    a_cr2 DECIMAL(16,2) NOT NULL,
    a_drn1 DECIMAL(16,4) NOT NULL,
    a_crn1 DECIMAL(16,4) NOT NULL,
    a_baln1 DECIMAL(16,4) NOT NULL,
    a_drn2 DECIMAL(16,4) NOT NULL,
    a_crn2 DECIMAL(16,4) NOT NULL,
    a_drf1 DECIMAL(16,2) NOT NULL,
    a_crf1 DECIMAL(16,2) NOT NULL,
    a_balf1 DECIMAL(16,2) NOT NULL,
    a_drf2 DECIMAL(16,2) NOT NULL,
    a_crf2 DECIMAL(16,2) NOT NULL,
    a_est DECIMAL(16,2) NOT NULL,
    a_estn DECIMAL(16,4) NOT NULL,
    a_estf DECIMAL(16,2) NOT NULL,
    PRIMARY KEY (a_yymm, a_no)
) ENGINE=InnoDB;

-- 表: arwoff
DROP TABLE IF EXISTS arwoff;
CREATE TABLE arwoff (
    w_no DECIMAL(8,0) NOT NULL,
    t_no DECIMAL(8,0) NOT NULL,
    w_date DATETIME NULL,
    w_par VARCHAR(30) NULL,
    w_amt DECIMAL(16,2) NULL,
    w_dir VARCHAR(1) NULL,
    w_man VARCHAR(8) NULL,
    PRIMARY KEY (w_no, t_no)
) ENGINE=InnoDB;

-- 表: artran
DROP TABLE IF EXISTS artran;
CREATE TABLE artran (
    t_no DECIMAL(8,0) NOT NULL,
    t_date DATETIME NULL,
    t_class VARCHAR(4) NULL,
    t_cust VARCHAR(16) NULL,
    t_dept VARCHAR(8) NULL,
    t_item VARCHAR(8) NULL,
    t_refno VARCHAR(20) NULL,
    t_par VARCHAR(255) NULL,
    t_amt DECIMAL(16,2) NULL,
    t_bal DECIMAL(16,2) NULL,
    t_famt DECIMAL(16,2) NULL,
    t_rate DECIMAL(16,6) NULL,
    t_begdate DATETIME NULL,
    t_enddate DATETIME NULL,
    t_manl VARCHAR(8) NULL,
    t_writeoff VARCHAR(1) NULL,
    t_post VARCHAR(1) NULL,
    t_void VARCHAR(1) NULL,
    t_SignMan VARCHAR(8) NULL,
    t_amtall DECIMAL(16,2) NULL,
    t_disrate DECIMAL(16,4) NULL,
    t_disamt DECIMAL(16,2) NULL,
    t_trans VARCHAR(1) NULL,
    t_taxid VARCHAR(7) NULL,
    PRIMARY KEY (t_no)
) ENGINE=InnoDB;

CREATE INDEX IX_artran_cust ON artran (t_cust);

-- 表: aritem
DROP TABLE IF EXISTS aritem;
CREATE TABLE aritem (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    enam VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    status VARCHAR(1) NULL,
    a_no VARCHAR(20) NULL,
    f_no VARCHAR(8) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    iscard VARCHAR(1) NULL DEFAULT 'N',
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: ardept
DROP TABLE IF EXISTS ardept;
CREATE TABLE ardept (
    code VARCHAR(8) NOT NULL,
    name VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    status VARCHAR(1) NULL,
    memo VARCHAR(30) NULL,
    flag VARCHAR(1) NULL,
    cust1 VARCHAR(16) NULL,
    cust2 VARCHAR(16) NULL,
    cust3 VARCHAR(16) NULL,
    cust4 VARCHAR(16) NULL,
    cust5 VARCHAR(16) NULL,
    cust6 VARCHAR(16) NULL,
    cust7 VARCHAR(16) NULL,
    cust8 VARCHAR(16) NULL,
    cust9 VARCHAR(16) NULL,
    PRIMARY KEY (code)
) ENGINE=InnoDB;

-- 表: arcust 视图 (替换为表结构)
DROP TABLE IF EXISTS arcust;
CREATE TABLE arcust (
    code VARCHAR(16) NOT NULL,
    name VARCHAR(100) NULL,
    abbr VARCHAR(30) NULL,
    category VARCHAR(8) NULL,
    bankname VARCHAR(30) NULL,
    bankacct VARCHAR(30) NULL,
    taxid VARCHAR(20) NULL,
    address VARCHAR(100) NULL,
    zipcode VARCHAR(6) NULL,
    tel VARCHAR(100) NULL,
    fax VARCHAR(20) NULL,
    email VARCHAR(30) NULL,
    contact VARCHAR(20) NULL,
    signers VARCHAR(100) NULL,
    credit DECIMAL(16,2) NULL,
    begdt DATETIME NULL,
    enddt DATETIME NULL,
    a_no VARCHAR(20) NULL,
    bal DECIMAL(16,2) NULL,
    status VARCHAR(1) NULL,
    interval VARCHAR(4) NULL,
    discount VARCHAR(4) NULL,
    memo VARCHAR(100) NULL,
    flag VARCHAR(1) NULL,
    photo VARCHAR(30) NULL,
    FisCreditCard VARCHAR(50) NULL
) ENGINE=InnoDB;

-- 表: fcprocnet
DROP TABLE IF EXISTS fcprocnet;
CREATE TABLE fcprocnet (
    procline INT NOT NULL AUTO_INCREMENT,
    procid INT NULL,
    netingr VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    piece DECIMAL(13,4) NULL,
    pieceunit VARCHAR(30) NULL,
    netrate DECIMAL(12,4) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    PRIMARY KEY (procline),
    FOREIGN KEY (procid) REFERENCES fcproc (procid),
    UNIQUE KEY index_procidnetingr (procid, netingr)
) ENGINE=InnoDB;

-- 表: fcprocingr
DROP TABLE IF EXISTS fcprocingr;
CREATE TABLE fcprocingr (
    procline INT NOT NULL AUTO_INCREMENT,
    procid INT NULL,
    ivitem VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    piece DECIMAL(13,4) NULL,
    pieceunit VARCHAR(30) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    PRIMARY KEY (procline),
    FOREIGN KEY (procid) REFERENCES fcproc (procid),
    UNIQUE KEY index_procidivitem (procid, ivitem)
) ENGINE=InnoDB;

-- 表: fcstdrcpnet
DROP TABLE IF EXISTS fcstdrcpnet;
CREATE TABLE fcstdrcpnet (
    rcpline INT NOT NULL AUTO_INCREMENT,
    rcpid INT NULL,
    netingr VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    minqty DECIMAL(13,4) NULL,
    maxqty DECIMAL(13,4) NULL,
    netrate DECIMAL(12,4) NULL,
    piece DECIMAL(13,4) NULL,
    pieceunit VARCHAR(30) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (rcpline),
    FOREIGN KEY (rcpid) REFERENCES fcstdrcp (rcpid),
    UNIQUE KEY index_rcpidnetingr (rcpid, netingr)
) ENGINE=InnoDB;

-- 表: fcstdrcpingr
DROP TABLE IF EXISTS fcstdrcpingr;
CREATE TABLE fcstdrcpingr (
    rcpline INT NOT NULL AUTO_INCREMENT,
    rcpid INT NULL,
    ivitem VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    piece DECIMAL(13,4) NULL,
    pieceunit VARCHAR(30) NULL,
    price DECIMAL(12,2) NULL,
    amt DECIMAL(12,2) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (rcpline),
    FOREIGN KEY (rcpid) REFERENCES fcstdrcp (rcpid),
    UNIQUE KEY index_rcpidivitem (rcpid, ivitem)
) ENGINE=InnoDB;

-- 表: fccardi
DROP TABLE IF EXISTS fccardi;
CREATE TABLE fccardi (
    cardline INT NOT NULL AUTO_INCREMENT,
    cardid INT NULL,
    nettype VARCHAR(8) NULL,
    netingr VARCHAR(16) NULL,
    qty DECIMAL(13,4) NULL,
    piece DECIMAL(13,4) NULL,
    pieceunit VARCHAR(30) NULL,
    memo VARCHAR(50) NULL,
    flag VARCHAR(1) NULL,
    PRIMARY KEY (cardline),
    FOREIGN KEY (cardid) REFERENCES fccard (cardid)
) ENGINE=InnoDB;

-- 表: AppRpt 视图 (替换为表结构)
DROP TABLE IF EXISTS AppRpt;
CREATE TABLE AppRpt (
    rptDate DATETIME NULL,
    rptShift INT NULL,
    rptDeptGroup VARCHAR(8) NULL,
    rptDeptName VARCHAR(50) NULL,
    rptItemType VARCHAR(20) NULL,
    rptItemGroup VARCHAR(50) NULL,
    rptItemName VARCHAR(80) NULL,
    rptIncome DECIMAL(12,2) NULL,
    rptIncome1 DECIMAL(12,2) NULL,
    rptMemo VARCHAR(255) NULL,
    rptMemo2 VARCHAR(255) NULL,
    rptKey BIGINT NULL
) ENGINE=InnoDB;

-- 表: Signman 视图 (替换为表结构)
DROP TABLE IF EXISTS Signman;
CREATE TABLE Signman (
    CustID VARCHAR(16) NULL,
    SignID VARCHAR(8) NULL,
    Signname VARCHAR(60) NULL,
    Photo VARCHAR(30) NULL,
    Memo VARCHAR(30) NULL,
    Flag VARCHAR(1) NULL,
    Fispub VARCHAR(1) NULL
) ENGINE=InnoDB;

-- 表: V_othercode_eqp 视图 (替换为表结构)
DROP TABLE IF EXISTS V_othercode_eqp;
CREATE TABLE V_othercode_eqp (
    sign VARCHAR(1) NULL,
    occode VARCHAR(8) NULL,
    ocname VARCHAR(20) NULL,
    ocmemo VARCHAR(255) NULL,
    category VARCHAR(20) NULL,
    flag VARCHAR(1) NULL
) ENGINE=InnoDB;

-- 表: V_othercode 视图 (替换为表结构)
DROP TABLE IF EXISTS V_othercode;
CREATE TABLE V_othercode (
    sign VARCHAR(1) NULL,
    ocCode VARCHAR(8) NULL,
    ocName VARCHAR(24) NULL,
    ocMemo VARCHAR(255) NULL,
    category VARCHAR(24) NULL,
    flag INT NULL,
    clas VARCHAR(2) NULL
) ENGINE=InnoDB;

-- 表: uGroupObject
DROP TABLE IF EXISTS uGroupObject;
CREATE TABLE uGroupObject (
    GroupID INT NOT NULL,
    ObjID INT NOT NULL,
    PRIMARY KEY (GroupID, ObjID),
    FOREIGN KEY (GroupID) REFERENCES uGroup (GroupID),
    FOREIGN KEY (ObjID) REFERENCES uObject (ObjID)
) ENGINE=InnoDB;

-- 表: uUser
DROP TABLE IF EXISTS uUser;
CREATE TABLE uUser (
    UserID VARCHAR(8) NOT NULL,
    DeptCode VARCHAR(8) NOT NULL,
    UsrName VARCHAR(30) NOT NULL,
    UsrPY VARCHAR(30) NULL,
    EName VARCHAR(30) NULL,
    PWD VARCHAR(32) NULL,
    Saler TINYINT(1) NOT NULL DEFAULT 1,
    Permit TINYINT(1) NOT NULL DEFAULT 0,
    IcCardID VARCHAR(30) NULL,
    Remarks VARCHAR(255) NULL,
    token VARCHAR(50) NULL,
    tokentime DATETIME NULL,
    PRIMARY KEY (UserID),
    FOREIGN KEY (DeptCode) REFERENCES uDept (DeptCode)
) ENGINE=InnoDB;

-- 表: uGroupUser
DROP TABLE IF EXISTS uGroupUser;
CREATE TABLE uGroupUser (
    GroupID INT NOT NULL,
    UserID VARCHAR(8) NOT NULL,
    PRIMARY KEY (GroupID, UserID),
    FOREIGN KEY (GroupID) REFERENCES uGroup (GroupID),
    FOREIGN KEY (UserID) REFERENCES uUser (UserID)
) ENGINE=InnoDB;

-- 表: Fccardi_History
DROP TABLE IF EXISTS Fccardi_History;
CREATE TABLE Fccardi_History (
    cardline INT NOT NULL AUTO_INCREMENT,
    CardId INT NOT NULL,
    EffectDate DATETIME NOT NULL,
    Nettype VARCHAR(8) NULL,
    Netingr VARCHAR(16) NULL,
    Qty DECIMAL(16,4) NULL,
    Piece DECIMAL(16,4) NULL,
    PieceUnit VARCHAR(30) NULL,
    PRIMARY KEY (cardline)
) ENGINE=InnoDB;

-- 表: Ivitem_Costprice
DROP TABLE IF EXISTS Ivitem_Costprice;
CREATE TABLE Ivitem_Costprice (
    IvitemId VARCHAR(16) NOT NULL,
    PriceDate DATETIME NOT NULL,
    Unit VARCHAR(8) NULL,
    Price DECIMAL(16,4) NULL,
    PRIMARY KEY (IvitemId, PriceDate)
) ENGINE=InnoDB;

-- =====================================================
-- 存储过程转换说明
-- =====================================================
-- 由于存储过程数量众多且逻辑复杂，此处仅提供转换框架
-- 实际使用时需要逐个转换存储过程，主要转换点：
-- 1. 所有 OUTPUT 参数改为 OUT
-- 2. 动态SQL使用 PREPARE/EXECUTE
-- 3. 游标语法调整
-- 4. 系统函数替换 (@@IDENTITY -> LAST_INSERT_ID(), @@ROWCOUNT -> ROW_COUNT())
-- 5. 错误处理使用 DECLARE EXIT HANDLER
-- =====================================================

-- 示例存储过程框架
DELIMITER //

-- 示例: UspOutputData 存储过程转换框架
DROP PROCEDURE IF EXISTS UspOutputData//
CREATE PROCEDURE UspOutputData(IN tablename VARCHAR(64))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE column_name VARCHAR(64);
    DECLARE data_type VARCHAR(64);
    DECLARE col_list TEXT DEFAULT '';
    DECLARE data_list TEXT DEFAULT '';
    DECLARE sql_stmt TEXT;
    DECLARE has_identity INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT COLUMN_NAME, DATA_TYPE 
        FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = tablename
        ORDER BY ORDINAL_POSITION;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 检查表是否存在
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables 
                   WHERE table_schema = DATABASE() 
                   AND table_name = tablename 
                   AND table_type = 'BASE TABLE') THEN
        SELECT 'The object not exists or is not a table' AS message;
        RETURN;
    END IF;
    
    -- 检查是否有自增列
    SELECT COUNT(*) INTO has_identity 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = tablename 
    AND EXTRA LIKE '%auto_increment%';
    
    IF has_identity > 0 THEN
        SELECT CONCAT('SET IDENTITY_INSERT ', tablename, ' ON') AS message;
    END IF;
    
    -- 构建动态SQL（简化版）
    SET sql_stmt = CONCAT('SELECT CONCAT(''INSERT INTO ', tablename, ' VALUES('', ',
        'CONCAT_WS('','', ', 
        (SELECT GROUP_CONCAT(CONCAT('COALESCE(', COLUMN_NAME, ', ''NULL'')')) 
         FROM information_schema.COLUMNS 
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tablename), 
        '), '')'') FROM ', tablename);
    
    -- 执行动态SQL
    PREPARE stmt FROM sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    IF has_identity > 0 THEN
        SELECT CONCAT('SET IDENTITY_INSERT ', tablename, ' OFF') AS message;
    END IF;
END//

-- 示例: uf_LanguageType 函数转换
DROP FUNCTION IF EXISTS uf_LanguageType//
CREATE FUNCTION uf_LanguageType() 
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE collation_name VARCHAR(128);
    DECLARE ftype VARCHAR(18);
    
    -- 获取数据库字符集
    SELECT DEFAULT_COLLATION_NAME INTO collation_name
    FROM information_schema.SCHEMATA 
    WHERE SCHEMA_NAME = DATABASE();
    
    -- 根据字符集判断语言
    SET ftype = CASE 
        WHEN collation_name LIKE '%gbk%' OR collation_name LIKE '%chinese%' THEN 'cn'
        WHEN collation_name LIKE '%big5%' THEN 'tw'
        ELSE 'en'
    END;
    
    RETURN RTRIM(ftype);
END//

-- 示例: uf_GetLockUser 函数转换
DROP FUNCTION IF EXISTS uf_GetLockUser//
CREATE FUNCTION uf_GetLockUser(KeyValue VARCHAR(16), Val VARCHAR(16))  
RETURNS VARCHAR(8)
DETERMINISTIC
BEGIN
    -- MySQL 没有 context_info 的对应功能，需要根据实际业务实现
    -- 这里返回空字符串作为占位
    RETURN '';
END//

-- 示例: pr_Pub_SetContexInfo 存储过程转换
DROP PROCEDURE IF EXISTS pr_Pub_SetContexInfo//
CREATE PROCEDURE pr_Pub_SetContexInfo(IN FUserID VARCHAR(15), IN Ftype VARCHAR(12))
BEGIN
    -- MySQL 没有 CONTEXT_INFO，此过程需要根据实际业务重新实现
    -- 这里作为空实现占位
    SELECT CONCAT('Set context info for user: ', IFNULL(FUserID, ''), ', type: ', IFNULL(Ftype, '')) AS message;
END//

-- 示例: pr_id 存储过程转换
DROP PROCEDURE IF EXISTS pr_id//
CREATE PROCEDURE pr_id(IN key_val CHAR(12), IN step_val INTEGER, OUT value_val INTEGER)
BEGIN
    DECLARE current_val INTEGER;
    
    START TRANSACTION;
    
    -- 检查计数器是否存在
    SELECT CAST(memo AS UNSIGNED) INTO current_val 
    FROM prm WHERE code = key_val;
    
    IF current_val IS NULL THEN
        INSERT INTO prm(code, memo) VALUES (key_val, CAST(step_val AS CHAR));
        SET value_val = step_val;
    ELSE
        UPDATE prm SET memo = CAST(current_val + step_val AS CHAR) WHERE code = key_val;
        SET value_val = current_val + step_val;
    END IF;
    
    COMMIT;
END//

-- 示例: pr_cust_query 存储过程转换
DROP PROCEDURE IF EXISTS pr_cust_query//
CREATE PROCEDURE pr_cust_query(IN as_item VARCHAR(8), IN as_clas VARCHAR(1))
BEGIN
    DECLARE count_val INT;
    
    -- 取单一编码
    SELECT COUNT(*) INTO count_val 
    FROM cust 
    WHERE c_code = as_item AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas;
    
    IF count_val > 0 THEN
        SELECT c_code, c_name, c_isdtl, c_levels, c_category, 
               c_status, 
               (SELECT f_GetSupplierBal(c_code)) AS c_bal,
               c_credit, c_begdt, c_enddt, c_bankname, 
               c_bankacc, c_taxid, c_address, c_zipcode, c_tel, c_contact, 
               c_accno, CASE c_interval WHEN 'C' THEN c_memo ELSE c_interval END AS c_interval,
               c_discount, c_dscr, c_clas, c_custtype, pym
        FROM cust 
        WHERE c_code = as_item AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas
        ORDER BY cust.c_code ASC;
        RETURN;
    END IF;
    
    -- 取编码类似的记录
    SELECT COUNT(*) INTO count_val 
    FROM cust 
    WHERE c_code LIKE CONCAT('%', as_item, '%') AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas;
    
    IF count_val > 0 THEN
        SELECT c_code, c_name, c_isdtl, c_levels, c_category, 
               c_status, 
               (SELECT f_GetSupplierBal(c_code)) AS c_bal,
               c_credit, c_begdt, c_enddt, c_bankname, 
               c_bankacc, c_taxid, c_address, c_zipcode, c_tel, c_contact, 
               c_accno, CASE c_interval WHEN 'C' THEN c_memo ELSE c_interval END AS c_interval,
               c_discount, c_dscr, c_clas, c_custtype, pym
        FROM cust 
        WHERE c_code LIKE CONCAT('%', as_item, '%') AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas
        ORDER BY cust.c_code ASC;
        RETURN;
    END IF;
    
    -- 取名称及助记码类似的记录
    SELECT COUNT(*) INTO count_val 
    FROM cust 
    WHERE (UPPER(c_name) LIKE CONCAT('%', UPPER(as_item), '%') 
           OR UPPER(pym) LIKE CONCAT('%', UPPER(as_item), '%')) 
           AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas;
    
    IF count_val > 0 THEN
        SELECT c_code, c_name, c_isdtl, c_levels, c_category, 
               c_status, 
               (SELECT f_GetSupplierBal(c_code)) AS c_bal,
               c_credit, c_begdt, c_enddt, c_bankname, 
               c_bankacc, c_taxid, c_address, c_zipcode, c_tel, c_contact, 
               c_accno, CASE c_interval WHEN 'C' THEN c_memo ELSE c_interval END AS c_interval,
               c_discount, c_dscr, c_clas, c_custtype, pym
        FROM cust 
        WHERE (UPPER(c_name) LIKE CONCAT('%', UPPER(as_item), '%') 
               OR UPPER(pym) LIKE CONCAT('%', UPPER(as_item), '%')) 
               AND c_isdtl = '1' AND c_status = '1' AND c_clas = as_clas
        ORDER BY cust.c_code ASC;
        RETURN;
    END IF;
    
    -- 默认返回空结果集
    SELECT c_code, c_name, c_isdtl, c_levels, c_category, 
           c_status, 
           (SELECT f_GetSupplierBal(c_code)) AS c_bal,
           c_credit, c_begdt, c_enddt, c_bankname, 
           c_bankacc, c_taxid, c_address, c_zipcode, c_tel, c_contact, 
           c_accno, CASE c_interval WHEN 'C' THEN c_memo ELSE c_interval END AS c_interval,
           c_discount, c_dscr, c_clas, c_custtype, pym
    FROM cust
    WHERE c_clas = as_clas
    AND 1 = 0;  -- 返回空集
END//

DELIMITER ;

-- =====================================================
-- 函数 f_GetSupplierBal, f_GetServerDb, f_GetPrm, 
-- f_GetOutletRate, f_GetCvrnum, f_GetCustBal, f_getcust,
-- f_GetAccPrd, f_FBC_GetPrevPrd, f_FBC_GetPrdDate,
-- f_FBC_GetDatePrd, f_FBC_GetCitem, f_EQP_GetMonthDepr,
-- f_GgetLastPos, f_autoaddstr 等函数需要类似转换
-- =====================================================

-- =====================================================
-- 转换完成
-- =====================================================
-- 说明：
-- 1. 所有表已创建，CHAR类型已替换为VARCHAR
-- 2. IDENTITY 已替换为 AUTO_INCREMENT
-- 3. 所有方括号已移除
-- 4. 存储过程和函数需要根据实际业务逻辑进一步调整
-- 5. 部分SQL Server特有的系统表引用需要根据MySQL替代方案修改
-- 6. 视图已转换为表结构，可根据需要重新创建为视图
-- =====================================================