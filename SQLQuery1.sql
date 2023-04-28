create database CourseDb

create table Employess(
[Id] int primary key identity(1,1),
[Name] nvarchar(50),
[Age] int,
[Adress] nvarchar(50)
)
insert into Employess(
[Name],
[Age],
[Adress]
)values('Orxan',21,'Ankara'),
('Nahid',20,'Akcakoca'),
('Sinan',19,'Akcakoca'),
('Ahmet',35,'Baku'),
('Emre',16,'Rize'),
('Hasan',54,'Duzce'),
('Busra',25,'Istanbul')



create table Customers(
[Id] int primary key identity(1,1),
[Name] nvarchar(50),
[Age] int,
[Adress] nvarchar(50)
)
insert into Customers(
[Name],
[Age],
[Adress]
)values('Orxan',21,'Ankara'),
('Ipek',18,'Izmir'),
('Ceyhun',38,'Sahil'),
('Amil',23,'Neftciler'),
('Ferid',36,'Nerimanov'),
('Ali',20,'Yigilca'),
('Mami',28,'Inonu')



select *  from Employess
union
select * from Customers

select *  from Employess
union all
select * from Customers


select *  from Employess
except
select * from Customers


select *  from Employess
intersect
select * from Customers

select GETDATE()

select * from Employess
order by Age asc

select * from Employess
order by Age desc

select * from Employess where Id>3
order by Age desc

select Count(*) as 'Count by age',Age from Employess where [Age]>19
group by Age

select Count(*) as 'Count by age',Age from Employess where [Age]>19
group by Age
having Count(*)>1
order by  Count(*) desc


create view vw_StudentsByAge As
select * from Teachers where [Age]>25

select * from vw_StudentsByAge

create view vw_TeachersBySalary3
AS
 select top 100 percent 
 Count(*) as Count,Salary,Age
 From Teachers
 group by Salary,Age


 select * from vw_TeachersBySalary  order by Age desc

 create function GetTeachersCountByAge()
 returns int
 as
 begin
 declare @age int
   select  @age= Count(*) from  Teachers
   return  @age 
 end



 select dbo.GetTeachersCountByAge()


  create function GetTeachersCountByAgeStatic()
 returns int
 as
 begin
 declare @age int
 declare @mainAge int=30
   select  @age= Count(*) from  Teachers where Age>@mainAge 
   return  @age 
 end

 select dbo.GetTeachersCountByAgeStatic()


   create function GetTeachersCountByAge(@age int)
 returns int
 as
 begin
 declare @count int
   select  @count= Count(*) from  Teachers where Age>@age 
   return  @count 
 end

 select dbo.GetTeachersCountByAge(30)

 create function GetTeachersAverageSalaryByCondition( @Id int )
 returns float
 begin 
 declare @sum float=cast(select sum(Age) from Teachers where Id>@Id) as float)
  declare @count float=cast(select count(Age) from Teachers where Id>@Id) as float)
  return  @sum/@count
 end

 select dbo.GetTeachersAverageSalaryByCondition(1)


 
 create function GetTeachersAverageSalaryByCondition( @Id int )
 returns decimal
 begin 
 declare @avg decimal
 select  @avg=AVG(Salary) from Teachers where  Id>@Id
 return @avg
 end

 select dbo.GetTeachersAverageSalaryByCondition(4)


 create procedure usp_InsertTeacher
@name nvarchar(50),
@surname nvarchar(50),
@age int,
@email nvarchar(50),
@salary decimal
as
begin
insert into Teachers([Name],[Surname],[Age],[Email],[Salary])
values(@name,@surname,@age,@email,@salary)
end

exec usp_InsertTeacher 'Orxan','Hesen',21,'orxanhsn@gmail.com',10000


create procedure usp_SumOfNums
@num1 int,
@num2 int 
as
select @num1+@num2

exec usp_SumOfNums 5,7


create table TeacherLogs (
[Id] int primary key identity(1,1),
[TeacherId] int,
[Operation] nvarchar(50),
[Date] datetime
)
create trigger trg_InsertTeacher on Teachers
for insert
as
begin
   insert into TeacherLogs([TeacherId],[Operation],[Date])
   select Id,'Insert',GETDATE() from inserted
end

create trigger trg_deleteTeacher on Teachers
after delete 
as
begin
   insert into TeacherLogs([TeacherId],[Operation],[Date])
   select Id,'Deleted',GETDATE() from deleted
end

delete from Teachers where Id=10