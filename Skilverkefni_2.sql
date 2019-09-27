use 09080124440_progresstracker_v6;
/* 1:
	Smíðið trigger fyrir insert into Restrictors skipunina. 
	Triggernum er ætlað að koma í veg fyrir að einhver áfangi sé undanfari eða samfari síns sjálfs. 
	með öðrum orðum séu courseNumber og restrictorID með sama innihald þá stoppar triggerinn þetta með
	því að kasta villu og birta villuboð.
	Dæmi um insert sem triggerinn á að stoppa: insert into Restrictors values('GSF2B3U','GSF2B3U',1);
*/
delimiter $$
drop trigger if exists Restrict_Courses $$

create trigger Restrict_Courses
before insert on restrictors
for each row
begin
	declare msg varchar(255);
    if(new.courseNumber = new.restrictorID)
		then set msg = concat("Það er ekki hægt að setja sama restrictor og coursenumber",cast(new.restrictorID as char));
		signal sqlstate '45000' set message_text = msg;
    end if;
end$$


-- 2:
-- Skrifið samskonar trigger fyrir update Restrictors skipunina.
delimiter $$
drop trigger if exists Restrict_Courses $$

create trigger Restrict_Courses
before update on restrictors
for each row
begin
	declare msg varchar(255);
    if(new.courseNumber = new.restrictorID)
		then set msg = concat("Það er ekki hægt að setja sama restrictor og coursenumber",cast(new.restrictorID as char));
		signal sqlstate '45000' set message_text = msg;
    end if;
end$$

/*
	3:
	Skrifið stored procedure sem leggur saman allar einingar sem nemandinn hefur lokið.
    Birta skal fullt nafn nemanda, heiti námsbrautar og fjölda lokinna eininga(
	Aðeins skal velja staðinn áfanga. passed = true
*/
delimiter $$
drop procedure if exists TotalCredit $$

create procedure TotalCredit(studentname varchar(50))
begin
select	concat(students.firstName," ",students.lastName) as FullName, 
		tracks.trackName,
		sum(courses.courseCredits) as TotalCredit
        from registration 
        join students on students.studentID = registration.studentID
        join courses on courses.courseNumber = registration.courseNumber
        join tracks on tracks.trackID = registration.trackID
        where studentname = students.firstName && registration.passed = true;
        
end$$

delimiter ;

call TotalCredit('Guðrún');
/*
	4:
	Skrifið 3 stored procedure-a:
    AddStudent()
    AddMandatoryCourses()
    Hugmyndin er að þegar AddStudent hefur insertað í Students töfluna þá kallar hann á AddMandatoryCourses() sem skráir alla
    skylduáfanga á nemandann.
    Að endingu skrifið þið stored procedure-inn StudentRegistration() sem nota skal við sjálfstæða skráningu áfanga nemandans.
*/
delimiter $$

drop procedure if exists AddStudent $$
create procedure AddStudent()
begin
end $$

delimiter ;


delimiter $$

drop procedure if exists AddManditoryCourses $$
create procedure AddManditoryCourses()
begin
end $$

delimiter ;

delimiter $$

drop procedure if exists StudentRegistration $$
create procedure StudentRegistration()
begin
end $$

delimiter ;