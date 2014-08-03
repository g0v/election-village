election-village
================

中選會 2010 年 村里長候選人及得票數爬蟲

資料來源:

  * 非直轄市: http://db.cec.gov.tw/histQuery.jsp?voteCode=20100601S1E1&qryType=ctks
  * 直轄市: http://db.cec.gov.tw/histQuery.jsp?voteCode=20101101V1B3&qryType=ctks

Usage
----------------

安裝必要套件:

    npm install LiveScript
    npm install request cheerio

執行爬蟲程式:

    node_modules/.bin/lsc main.ls

結果儲存在 data/region.json, application/json 格式, 範例:

    {
        "宜蘭縣蘇澳鎮龍德里": [
            # 候選人   號次  性別  出生年  政黨  得票數  得票率  當選   現任
            ["王明義", 1,   "男", 1954,   "無", 940,    43.82,  false, "是"], 
            ...
        ], 
        ...
    }

License
---------------

MIT License.
