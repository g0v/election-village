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

------------

簡單的範例分析
============

出生年次分佈
------------

  * 1921 : 1 人
  * 1925 : 5 人
  * 1926 : 2 人
  * 1927 : 6 人
  * 1928 : 8 人
  * 1929 : 12 人
  * 1930 : 16 人
  * 1931 : 20 人
  * 1932 : 20 人
  * 1933 : 34 人
  * 1934 : 44 人
  * 1935 : 67 人
  * 1936 : 81 人
  * 1937 : 123 人
  * 1938 : 149 人
  * 1939 : 169 人
  * 1940 : 200 人
  * 1941 : 236 人
  * 1942 : 261 人
  * 1943 : 287 人
  * 1944 : 311 人
  * 1945 : 261 人
  * 1946 : 295 人
  * 1947 : 430 人
  * 1948 : 464 人
  * 1949 : 535 人
  * 1950 : 580 人
  * 1951 : 748 人
  * 1952 : 679 人
  * 1953 : 697 人
  * 1954 : 751 人
  * 1955 : 719 人
  * 1956 : 784 人
  * 1957 : 663 人
  * 1958 : 713 人
  * 1959 : 680 人
  * 1960 : 583 人
  * 1961 : 549 人
  * 1962 : 465 人
  * 1963 : 408 人
  * 1964 : 334 人
  * 1965 : 342 人
  * 1966 : 273 人
  * 1967 : 251 人
  * 1968 : 195 人
  * 1969 : 170 人
  * 1970 : 145 人
  * 1971 : 128 人
  * 1972 : 117 人
  * 1973 : 99 人
  * 1974 : 82 人
  * 1975 : 66 人
  * 1976 : 55 人
  * 1977 : 47 人
  * 1978 : 43 人
  * 1979 : 31 人
  * 1980 : 22 人
  * 1981 : 18 人
  * 1982 : 14 人
  * 1983 : 13 人
  * 1984 : 6 人
  * 1985 : 10 人
  * 1986 : 4 人
  * 1987 : 1 人
  * 最多人 (784人) 出生的年次為 1956 年

男女比例
------------
男性:女性 = 13377 : 2145

政黨別分佈
------------
  * 無黨籍及未經政黨推薦 : 4927 人
  * 中國國民黨 : 3501 人
  * 民主進步黨 : 583 人
  * 綠黨 : 1 人
  * 親民黨 : 1 人
  * 中華統一促進黨 : 2 人
  * 台灣團結聯盟 : 2 人
  * 無 : 6505 人

