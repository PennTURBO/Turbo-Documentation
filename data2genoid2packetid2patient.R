setwd("C:/Users/Mark Miller/Desktop/wes_lof_aggreagted/wes_lof/")

lof.mat.file <-
  "wes-lof lof data/eve.UPENN_Freeze_One.L2.M3.lofMatrix.txt"

print(Sys.time())

wes.lof.frame <- read.table(
  file = lof.mat.file,
  header = TRUE,
  sep = "\t",
  colClasses = "character",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

print(Sys.time())

print(dim(wes.lof.frame))

print(wes.lof.frame[wes.lof.frame$Sample == 'UPENN_UPENN10796_cfc48297', 'ZNF681(ENSG00000196172)'])

master_nophi_170419 <-
  read.csv("master_nophi_170419.csv",
           header = TRUE)

print(t(master_nophi_170419[master_nophi_170419$GENO_ID == 'UPENN_UPENN10796_cfc48297' , ]))

wes.lof.frame$placeholder <- "placeholder"

data2genoid <- wes.lof.frame[, c('Sample', 'placeholder')]

genoid2packetid <-
  master_nophi_170419[, c("GENO_ID", "PACKET_UUID")]

data2genoid2packetid <-
  merge(
    x = data2genoid,
    y = genoid2packetid,
    by.x = 'Sample',
    by.y = "GENO_ID",
    all = TRUE
  )

data2genoid2packetid <-
  data2genoid2packetid[, c("Sample", "PACKET_UUID")]

names(data2genoid2packetid) <- c("GENO_ID", "PACKET_UUID")


wes_pmbb_enc_patient_lookup_v3 <-
  read.csv(
    "C:/Users/Mark Miller/Desktop/real_wes/wes_pmbb_enc_patient_lookup_v3.csv",
    header = TRUE
  )

data2genoid2packetid2patient <-
  merge(
    x = data2genoid2packetid,
    y = wes_pmbb_enc_patient_lookup_v3,
    by.x = 'PACKET_UUID',
    by.y = "PACKETID",
    all = TRUE
  )

print(sapply(data2genoid2packetid2patient, class))

data2genoid2packetid2patient$GENO_ID <- factor(data2genoid2packetid2patient$GENO_ID)

print(sapply(data2genoid2packetid2patient, class))

print(summary(data2genoid2packetid2patient))


