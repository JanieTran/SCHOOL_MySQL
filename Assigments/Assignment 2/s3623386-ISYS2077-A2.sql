-- ======================================
-- ISYS2077 - Database Concepts
-- ASSIGNMENT 2
-- --------------------------------------
-- Student Name: Tran Thi Hong Phuong
-- Student ID: s3623386
-- Creation Date: 6th August, 2018
-- ======================================

-- ======================================
-- PART 1
-- ======================================

-- 1.1
-- Find the family and given names of academics
-- who are interested in the field number 292.
select a.famname, a.givename
from academic a, interest i
where a.acnum = i.acnum
  and i.fieldnum = 292;

-- 1.2
-- Find the paper number and title of papers
-- containing the word “database” in their title.
select p.panum, p.title
from paper p
where p.title like '%database%';

-- 1.3
-- Find the family and given names of academics
-- who have authored at least one paper
-- with the word “database” in the paper’s title.
select ac.famname, ac.givename
from academic ac, paper p, author au
where p.panum = au.panum
  and au.acnum = ac.acnum
  and exists(select *
             from paper p1
             where p1.panum = au.panum
               and p1.title like '%database%');

-- 1.4
-- Find the family and given names of academics
-- who have not authored any paper.
select a.famname, a.givename
from academic a
where a.acnum not in (select au.acnum
                      from author au);

-- 1.5
-- Find the family and given names of academics
-- who are working for the “University of Canberra”
-- who have not authored any paper.
select a.famname, a.givename
from academic a, department d
where a.deptnum = d.deptnum
  and d.instname = 'University of Canberra'
  and a.acnum not in (select au.acnum
                      from author au);

-- ======================================
-- PART 2
-- ======================================

-- 2.1
-- Find the total number of academics
-- who have an interest in databases
-- (you should look for the word “database” in both the Interest and Field tables).
select count(distinct a.acnum)
from academic a, field f, interest i
where a.acnum = i.acnum
  and i.fieldnum = f.fieldnum
  and (i.descrip like '%database%' or f.title like '%database%');

-- 2.2
-- Find how many academics are interested in the field number 292.
select count(distinct a.acnum)
from academic a, interest i
where a.acnum = i.acnum
  and i.fieldnum = 292;

-- 2.3
-- Find how many academics are interested in each field,
-- and order the results by the most popular fields first.
-- List the field number and the number of academics interested in each respective field.
select i.fieldnum, count(i.fieldnum) as num_ac_interested
from academic a, interest i
where a.acnum = i.acnum
group by i.fieldnum
order by num_ac_interested desc;

-- 2.4
-- Find the field number of the most popular field(s).
-- There could be many fields equal for the first place.
create view fields_order_by_popularity (fieldnum, num_ac_interested) as
  select i.fieldnum, count(i.fieldnum) as num_ac_interested
  from academic a, interest i
  where a.acnum = i.acnum
  group by i.fieldnum
  order by num_ac_interested desc;

select distinct i.fieldnum
from interest i
where i.fieldnum in (select fv.fieldnum
                     from fields_order_by_popularity fv
                     where fv.num_ac_interested = (select max(fv1.num_ac_interested)
                                                   from fields_order_by_popularity fv1));

-- 2.5
-- Find the family and given names of the academics
-- who are interested in the most popular field(s).

create view most_popular_fields (fieldnum) as
  select distinct i.fieldnum
  from interest i
  where i.fieldnum in (select fv.fieldnum
                       from fields_order_by_popularity fv
                       where fv.num_ac_interested = (select max(fv1.num_ac_interested)
                                                     from fields_order_by_popularity fv1));

select a.famname, a.givename
from academic a, interest i
where a.acnum = i.acnum
  and i.fieldnum in (select *
                     from most_popular_fields);

-- 2.6
-- Find the average number of academics interested in each field.
select avg(fv.num_ac_interested)
from fields_order_by_popularity fv;

-- 2.7
-- Find the number of papers authored by each academic.
-- List the academic number, family and given names, number of papers.
-- Order by the largest number of papers first.
-- Include academics who are not the author of any paper.
select ac.acnum, ac.famname, ac.givename, count(p.panum) as num_papers
from academic ac left outer join author au on ac.acnum = au.acnum
                 left outer join paper p on au.panum = p.panum
group by ac.acnum
order by num_papers desc;

-- 2.8
-- Find the family and given names of the academics
-- who are interested in less than 2 fields.
-- -- o	Using a GROUP BY.
select a.famname, a.givename
from academic a left outer join interest i
      on a.acnum = i.acnum
group by a.acnum
  having count(i.fieldnum) < 2;

-- -- o	Using a non-correlated sub-query and without using a GROUP BY.
select a.famname, a.givename
from academic a
where a.acnum in (select a1.acnum
                  from academic a1
                  where (select count(i.fieldnum)
                         from interest i
                         where i.acnum = a1.acnum) < 2);

-- -- o	Using a correlated sub-query and without using a GROUP BY.
select distinct a.famname, a.givename
from academic a
where (select count(i.fieldnum)
       from interest i
       where i.acnum = a.acnum) < 2;