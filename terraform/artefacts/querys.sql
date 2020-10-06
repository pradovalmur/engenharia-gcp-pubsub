
## Criação da dimensão Data ##

drop table if exists `testeengenharia.dw_tubes.tb_dim_date`;
create table `testeengenharia.dw_tubes.tb_dim_date`
as
SELECT 
  a.quote_date as date,
  EXTRACT(DAY FROM a.quote_date) as day,
  EXTRACT(DAYOFWEEK from a.quote_date) as dayWeek,
  EXTRACT(MONTH FROM a.quote_date) as month,
  EXTRACT(quarter FROM a.quote_date) as quarter,
  EXTRACT(year FROM a.quote_date) as year
FROM `testeengenharia.tubes.tb_quoteprice` as a;

################################################################################################

## Criação da dimensão Tube_assembly ##

drop table if exists `testeengenharia.dw_tubes.tb_dim_tube_assembly`;
create table `testeengenharia.dw_tubes.tb_dim_tube_assembly`
as
select distinct
  a.tube_assembly_id,
  ROW_NUMBER() OVER() as id 
FROM `testeengenharia.tubes.tb_quoteprice` as a;

###############################################################################################

## Criação da dimensão supplier ##

drop table if exists `testeengenharia.dw_tubes.tb_dim_supplier`;
create table `testeengenharia.dw_tubes.tb_dim_supplier`
as
select distinct
  a.supplier,
  ROW_NUMBER() OVER() as id 
FROM `testeengenharia.tubes.tb_quoteprice` as a;

################################################################################################

## Criação da dimensão bracket_pricing ##

drop table if exists `testeengenharia.dw_tubes.tb_dim_bracket_pricing`;
create table `testeengenharia.dw_tubes.tb_dim_bracket_pricing`
as
select distinct
  a.bracket_pricing,
  ROW_NUMBER() OVER() as id 
FROM `testeengenharia.tubes.tb_quoteprice` as a;

################################################################################################

## Criação da fato quote price ##
drop table if exists `testeengenharia.dw_tubes.tb_fact_quotePrice`;
create table `testeengenharia.dw_tubes.tb_fact_quotePrice`
as
select 
qp.quote_date	,
ta.id as idtubeAssembly,
s.id as idSupplier,
bp.id as idBracketPrice,
sum(qp.annual_usage) as AnnualUsage,
sum(qp.min_order_quantity) as MinOrderQuantity,
sum(qp.quantity) as Quantity,
sum(qp.cost) as cost
from `testeengenharia.tubes.tb_quoteprice` as qp
left join `testeengenharia.dw_tubes.tb_dim_tube_assembly` as ta on qp.tube_assembly_id	= ta.tube_assembly_id
left join `testeengenharia.dw_tubes.tb_dim_supplier` as s on qp.supplier = s.supplier
left join `testeengenharia.dw_tubes.tb_dim_bracket_pricing` as bp on qp.bracket_pricing = bp.bracket_pricing
group by qp.quote_date,ta.id,s.id,bp.id
order by qp.quote_date 
limit 1000





