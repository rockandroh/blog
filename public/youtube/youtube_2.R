# Youtube Project 2

# Go roboticks!!!!

# library
library(dplyr)
library(tidyverse)
library(DT)
library(highfrequency)
library(xts)
library(tidyquant)
library(httr)
library(rvest)
library(readr)
library(stringr)


options(digits.secs=6)
options(scipen=999)
options(max.print = 99999999)
options(digits=10)
options(tz="Asia/Seoul")

# Data Prep -----------
y = '2021'
m = '01'
d = '25'
ymd = paste0(y,m,d)
ymd2 = paste(y,m,d, sep = '-')
wd_mac = "/Volumes/GoogleDrive/공유 드라이브/Project_TBD/Stock_Data/real_time/kiwoom_stocks/2021-01-25"
tbl =
  list.files(path = wd_mac, pattern = '.*stocks_trade.*\\.csv') %>%
  map_df(~readr::read_csv(paste(wd_mac,.,sep = '/'),
                          col_names = c('code','trade_date','timestamp','price','open','high','low','size','cum_size','ask1','bid1','rotation','bs_ratio', 'mkt_type', 'mkt_cap'),
                          col_types = cols(.default="d", code = "c")
  )
  )
sum(is.na(tbl))
gc()
dim(tbl)

# Basic cleaning and Save ----

tbl = 
  tbl %>%
  filter(mkt_type==2) %>%
  select('code','timestamp','price','size','ask1','bid1',
         'mkt_type','bs_ratio','mkt_cap','cum_size') %>%
  mutate_at(vars(timestamp), function(x) x*10000) %>%
  mutate_at(vars(code), function(x) paste0('KR',x)) %>%
  arrange(.,timestamp) %>%
  # mutate(DATE = paste(substr(as.character(timestamp),1,4),
  #                     substr(as.character(timestamp),5,6),
  #                     substr(as.character(timestamp),7,8),
  #                     sep ="-" 
  # )) %>%
  # mutate(TIME = paste(substr(as.character(timestamp),9,10),
  #                     substr(as.character(timestamp),11,12),
  #                     paste(substr(as.character(timestamp),13,14),
  #                           substr(as.character(timestamp),15,18),
  #                           sep='.'),
  #                     sep =":" 
  # )) %>%
  mutate(HMS = paste(substr(as.character(timestamp),9,10),
                     substr(as.character(timestamp),11,12),
                     substr(as.character(timestamp),13,14),
                      sep =":" 
  )) %>%
  mutate(DT = as.POSIXct(paste0(
    paste(substr(as.character(timestamp),1,4),
          substr(as.character(timestamp),5,6),
          substr(as.character(timestamp),7,8),
          sep ="-" 
    ), 
    ' ',
    paste(substr(as.character(timestamp),9,10),
          substr(as.character(timestamp),11,12),
          paste(substr(as.character(timestamp),13,14),
                substr(as.character(timestamp),15,18),
                sep='.'),
          sep =":" 
    )
    
  ))) %>%
  select(!c('timestamp', 'mkt_type')) %>%
  mutate(SPREAD = ask1 - bid1) %>%
  mutate(MONEY = price * size) %>%
  rename(SYMBOL = code) %>%
  rename(BID = bid1) %>%
  rename(OFR = ask1) %>%
  rename(SIZE = size) %>%
  rename(PRICE = price) %>%
  rename(VP = bs_ratio) %>%
  relocate(DT, HMS, SYMBOL, PRICE, SIZE, BID, OFR, VP)

# save it
write.csv(tbl, file=paste0(wd_mac,'/','df.csv'), row.names = FALSE)
head(tbl)
gc()



# Few sanity check ----
sum(is.na(tbl))
sum(tbl$PRICE < 0)
sum(tbl$SPREAD < 0)


# Get the list of code KOSPI/KOSDQ/ETF

## ETF: code_ETF ====
gen_otp_url =
  'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
gen_otp_data = list(
  trdDd = '20210129',
  share = '1',
  money = '1',
  csvxls_isNo = 'false',
  name = 'fileDown',
  url = 'dbms/MDC/STAT/standard/MDCSTAT04301'
)
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()
down_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'
down_ETF_KS = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()
code_ETF = down_ETF_KS %>%
  mutate(종목코드 = paste0('KR',종목코드)) %>%
  mutate(시장구분 = 'ETF') %>%
  mutate(업종명 = 기초지수_지수명) %>%
  select(종목코드, 종목명, 시장구분, 업종명)

## ETN: code_ETN ====
gen_otp_url =
  'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
gen_otp_data = list(
  trdDd = '20210129',
  share = '1',
  money = '1',
  csvxls_isNo = 'false',
  name = 'fileDown',
  url = 'dbms/MDC/STAT/standard/MDCSTAT06401'
)
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()
down_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'
down_ETN_KS = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()
code_ETN = down_ETN_KS %>%
  mutate(종목코드 = paste0('KR',종목코드)) %>%
  mutate(시장구분 = 'ETN') %>%
  mutate(업종명 = 기초지수_지수명) %>%
  select(종목코드, 종목명, 시장구분, 업종명)


## KOSPI: code_KOSPI ====
gen_otp_url =
  'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
gen_otp_data = list(
  mktId = 'STK',
  trdDd = '20210108',
  money = '1',
  csvxls_isNo = 'false',
  name = 'fileDown',
  url = 'dbms/MDC/STAT/standard/MDCSTAT03901'
)
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

down_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'
down_KOSPI_KS = POST(down_url, query = list(code = otp),
                     add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()
code_KOSPI = down_KOSPI_KS %>%
  mutate(종목코드 = paste0('KR',종목코드)) %>%
  select(종목코드, 종목명, 시장구분, 업종명)

## KOSDAQ: code_KOSDAQ ====
gen_otp_url =
  'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
gen_otp_data = list(
  mktId = 'KSQ',
  trdDd = '20210108',
  money = '1',
  csvxls_isNo = 'false',
  name = 'fileDown',
  url = 'dbms/MDC/STAT/standard/MDCSTAT03901'
)
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

down_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'
down_KSQ_KS = POST(down_url, query = list(code = otp),
                     add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()
code_KOSDAQ = down_KSQ_KS %>%
  mutate(종목코드 = paste0('KR',종목코드)) %>%
  select(종목코드, 종목명, 시장구분, 업종명)

####

## Naver Finance: naver_ticker_all ====

data = list()
# i = 0 은 코스피, i = 1 은 코스닥 종목
for (i in 0:1) {
  
  ticker = list()
  url =
    paste0('https://finance.naver.com/sise/',
           'sise_market_sum.nhn?sosok=',i,'&page=1')
  
  down_table = GET(url)
  
  # 최종 페이지 번호 찾아주기
  navi.final = read_html(down_table, encoding = "EUC-KR") %>%
    html_nodes(., ".pgRR") %>%
    html_nodes(., "a") %>%
    html_attr(.,"href") %>%
    strsplit(., "=") %>%
    unlist() %>%
    tail(., 1) %>%
    as.numeric()
  
  # 첫번째 부터 마지막 페이지까지 for loop를 이용하여 테이블 추출하기
  for (j in 1:navi.final) {
    
    # 각 페이지에 해당하는 url 생성
    url = paste0(
      'https://finance.naver.com/sise/',
      'sise_market_sum.nhn?sosok=',i,"&page=",j)
    down_table = GET(url)
    
    Sys.setlocale("LC_ALL", "English")
    # 한글 오류 방지를 위해 영어로 로케일 언어 변경
    
    table = read_html(down_table, encoding = "EUC-KR") %>%
      html_table(fill = TRUE)
    table = table[[2]] # 원하는 테이블 추출
    
    Sys.setlocale("LC_ALL", "Korean")
    # 한글을 읽기위해 로케일 언어 재변경
    
    table[, ncol(table)] = NULL # 토론식 부분 삭제
    table = na.omit(table) # 빈 행 삭제
    
    # 6자리 티커만 추출
    symbol = read_html(down_table, encoding = "EUC-KR") %>%
      html_nodes(., "tbody") %>%
      html_nodes(., "td") %>%
      html_nodes(., "a") %>%
      html_attr(., "href")
    
    symbol = sapply(symbol, function(x) {
      str_sub(x, -6, -1) 
    })
    
    symbol = unique(symbol)
    
    # 테이블에 티커 넣어준 후, 테이블 정리
    table$N = paste0('KR',symbol)
    colnames(table)[1] = "종목코드"
    
    rownames(table) = NULL
    ticker[[j]] = table
    
    Sys.sleep(0.5) # 페이지 당 0.5초의 슬립 적용
  }
  
  # do.call을 통해 리스트를 데이터 프레임으로 묶기
  ticker = do.call(rbind, ticker)
  data[[i + 1]] = ticker
}

# 코스피와 코스닥 테이블 묶기
naver_ticker_all = do.call(rbind, data) %>% as_tibble()



## Merge tickers ====
krx_ticker_all = rbind(code_ETF,
                       code_ETN,
                       code_KOSPI,
                       code_KOSDAQ)

dim(naver_ticker_all)[1] - dim(unique(naver_ticker_all)[ ,'종목명'])[1]
dim(krx_ticker_all)[1] - dim(unique(krx_ticker_all)[ ,'종목명'])[1]
dim(naver_ticker_all)[1] - dim(krx_ticker_all)[1]

# Anti_join and Semi_join
anti_join(krx_ticker_all[, '종목명'], 
        naver_ticker_all[ ,'종목명']) # setdiff
anti_join(naver_ticker_all[, '종목명'], 
          krx_ticker_all[ ,'종목명'])

KOR_ticker =
  merge(naver_ticker_all, krx_ticker_all,
                   by = intersect(names(naver_ticker_all),
                                  names(krx_ticker_all)),
                   all = FALSE
              ) %>%
  select(종목코드, 종목명, 업종명, 시장구분, 
         외국인비율, 상장주식수, PER, ROE, 액면가)

write.csv(KOR_ticker, file=paste0(wd_mac,'/','Kor_ticker.csv'), row.names = FALSE)

# 스팩 & 우선주 & ETN 지우기

KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']), ]  
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) == 0,]

# Split the data and filter the code! ====

dfs = split(tbl, tbl$SYMBOL)
ls.names = names(dfs)
ticker_final = ls.names[ls.names %in% KOR_ticker$종목코드]

# make two ts list and merge it after sampling ====

ts.names <- ticker_final
ts_merged <- vector("list", length(ts.names))
names(ts_merged) <- ts.names

for (dn in ts.names){
  
  temp1 = 
    data.table::as.data.table(dfs[[dn]]) %>%
    mutate(IND = getTradeDirection(.)) %>%
    mutate(BUY = ifelse(IND>0, SIZE, 0)) %>%
    mutate(SELL = ifelse(IND<0, SIZE, 0)) %>%
    mutate(BUY = replace(BUY, row_number() == 1, 0)) %>%
    mutate(SELL = replace(SELL, row_number() == 1, 0)) %>%
    mutate(SignedMoney = BUY*PRICE - SELL*PRICE) %>%
    mutate(SignedSize = BUY - SELL) %>%
    mutate(BUYcumsum = cumsum(BUY)) %>%
    mutate(SELLcumsum = cumsum(SELL)) %>%
    mutate(BSratio = round(BUYcumsum/SELLcumsum, 4)) %>%
    relocate(DT, VP, BSratio, SignedSize, BUY, SELL) %>%
    as.xts(subset(., select=-c(DT, DATE, HMS, TIME, SYMBOL)), 
           order.by = .$DT) %>%
    aggregateTS(., FUN='previoustick',
                alignBy = 'seconds',
                alignPeriod = 10
    )
  
  temp2 = 
    data.table::as.data.table(dfs[[dn]]) %>%
    mutate(IND = getTradeDirection(.)) %>%
    mutate(BUY = ifelse(IND>0, SIZE, 0)) %>%
    mutate(SELL = ifelse(IND<0, SIZE, 0)) %>%
    mutate(BUY = replace(BUY, row_number() == 1, 0)) %>%
    mutate(SELL = replace(SELL, row_number() == 1, 0)) %>%
    mutate(SignedMoney = BUY*PRICE - SELL*PRICE) %>%
    mutate(SignedSize = BUY - SELL) %>%
    mutate(BUYcumsum = cumsum(BUY)) %>%
    mutate(SELLcumsum = cumsum(SELL)) %>%
    mutate(BSratio = round(BUYcumsum/SELLcumsum, 4)) %>%
    relocate(VP, BSratio, SignedSize, BUY, SELL) %>%
    makeOHLCV(.,
              alignBy = 'seconds',
              alignPeriod = 10,
    )
  
  ts_merged[[dn]] = merge(temp1, temp2)
}

save(ts_merged, file=paste0(wd_mac,'/','ts_merged.Rdata'))

cut_time_of_day <- function(x, t_str_begin, t_str_end){
  
  tstr_to_sec <- function(t_str){
    #"09:00:00" to sec of day
    as.numeric(as.POSIXct(paste("1970-01-01", t_str), "UTC")) %% (24*60*60)
  }
  
  #POSIX ignores leap second
  #sec_of_day = as.numeric(index(x)) %% (24*60*60)                                #GMT only
  sec_of_day = {lt = as.POSIXlt(index(x)); lt$hour *60*60 + lt$min*60 + lt$sec}   #handle tzone
  sec_begin  = tstr_to_sec(t_str_begin)
  sec_end    = tstr_to_sec(t_str_end)
  
  return(x[ sec_of_day >= sec_begin & sec_of_day <= sec_end,])
}

# Get Time varying rank for every 10 seconds ----

cut_time_of_day(ts_merged$KR005930, '09:00:00', '09:01:00')


volume_df = as.data.frame(matrix(0, nrow = length(index)))
  
ts_merged






