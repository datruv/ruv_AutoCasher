CREATE TABLE IF NOT EXISTS `index_cashier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `huwon_code` varchar(255) NOT NULL,
  `item_code` varchar(255) NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr COLLATE=euckr_korean_ci;