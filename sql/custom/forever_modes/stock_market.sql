-- ============================================================
-- 股票市场 MVP
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS world.stock_company (
  id              INT UNSIGNED NOT NULL,
  name            VARCHAR(64) NOT NULL,
  ticker          VARCHAR(16) NOT NULL,
  price           DOUBLE NOT NULL DEFAULT 0,
  prev_close      DOUBLE NOT NULL DEFAULT 0,
  intrinsic       DOUBLE NOT NULL DEFAULT 0,
  volatility      DOUBLE NOT NULL DEFAULT 0.005,
  total_shares    BIGINT UNSIGNED NOT NULL DEFAULT 1000000,
  open_price      DOUBLE NOT NULL DEFAULT 0,
  high_price      DOUBLE NOT NULL DEFAULT 0,
  low_price       DOUBLE NOT NULL DEFAULT 0,
  volume          BIGINT UNSIGNED NOT NULL DEFAULT 0,
  last_day        INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO world.stock_company
  (id, name, ticker, price, prev_close, intrinsic, volatility, total_shares)
VALUES
  (1, '风险投资公司',   'VENT',  8.50,  8.50,  8.50,  0.012, 1000000),
  (2, '热砂集团',       'STMH', 12.00, 12.00, 12.00,  0.006, 1000000),
  (3, '铁炉堡矿业联合', 'IRON', 15.00, 15.00, 15.00,  0.004, 1000000),
  (4, '皇家药剂师协会', 'RASP',  9.00,  9.00,  9.00,  0.010, 1000000),
  (5, '侏儒工程协会',   'GNOM',  7.00,  7.00,  7.00,  0.011, 1000000),
  (6, '塞纳里奥议会',   'CENA', 11.00, 11.00, 11.00,  0.005, 1000000)
ON DUPLICATE KEY UPDATE
  name = VALUES(name), ticker = VALUES(ticker),
  intrinsic = VALUES(intrinsic), volatility = VALUES(volatility);

CREATE TABLE IF NOT EXISTS characters.character_stock (
  guid        INT UNSIGNED NOT NULL,
  company_id  INT UNSIGNED NOT NULL,
  shares      BIGINT UNSIGNED NOT NULL DEFAULT 0,
  available   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  avg_cost    DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT id, name, ticker, price, volatility FROM world.stock_company ORDER BY id;
