INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_kfc', 'KFC', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_kfc', 'KFC', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_kfc', 'KFC', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('kfc', 'KFC')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('kfc',0,'recrue','Recrue',12,'{}','{}'),
	('kfc',1,'novice','Novice',25,'{}','{}'),
	('kfc',2,'employed','Employé',36,'{}','{}'),
	('kfc',3,'viceboss','Co-gérant',48,'{}','{}'),
  	('kfc',4,'boss','Patron',0,'{}','{}')
;


INSERT INTO `items` (`name`, `label`) VALUES
	('pommedeterre', 'Pomme de terre'),
	('cornichons', 'Cornichons'),
	('cheddar', 'Cheddar'),
	('originalesauce', 'Sauce originale'),
	('bbqsauce', 'Sauce BBQ'),
	('steakboeuf', 'Steak de boeuf'),
	('steakboeufpremium', 'Steak de boeuf Premium'),
	('shotoriginal', 'The tower'),
	('doubleshotoriginal', 'Double Colonel'),
	('bbqshot', 'Tower BBQ'),
	('premiumshot', 'The kentucky'),
	('salar', 'Sel'),
	('menulivraison', 'Menu Livraison'),
	('frite', 'Portion de frite'),
	('fritedouble', 'Double portion de frite'),
	('chipechips', 'Chip&Chips')
;