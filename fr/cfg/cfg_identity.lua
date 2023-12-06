
local cfg = {}

-- cost of a new identity
cfg.new_identity_cost = 5000

-- phone format (max: 20 chars, use D for a random digit)
cfg.phone_format = "07DDDDDDDD"


-- config the random name generation (first join identity)
-- (I know, it's a lot of names for a little feature)
-- (cf: http://names.mongabay.com/most_common_surnames.htm)
cfg.random_first_names = {
  'Michael',
  'Christopher',
  'Jessica',
  'Matthew',
  'Ashley',
  'Jennifer',
  'Joshua',
  'Amanda',
  'Daniel',
  'David',
  'James',
  'Robert',
  'John',
  'Joseph',
  'Andrew',
  'Ryan',
  'Brandon',
  'Jason',
  'Justin',
  'Sarah',
  'William',
  'Jonathan',
  'Stephanie',
  'Brian',
  'Nicole',
  'Nicholas',
  'Anthony',
  'Heather',
  'Eric',
  'Elizabeth',
  'Adam',
  'Megan',
  'Melissa',
  'Kevin',
  'Steven',
  'Thomas',
  'Timothy',
  'Christina',
  'Kyle',
  'Rachel',
  'Laura',
  'Lauren',
  'Amber',
  'Brittany',
  'Danielle',
  'Richard',
  'Kimberly',
  'Jeffrey',
  'Amy',
  'Crystal',
  'Michelle',
  'Tiffany',
  'Jeremy',
  'Benjamin',
  'Mark',
  'Emily',
  'Aaron',
  'Charles',
  'Rebecca',
  'Jacob',
  'Stephen',
  'Patrick',
  'Sean',
  'Erin',
  'Zachary',
  'Jamie',
  'Kelly',
  'Samantha',
  'Nathan',
  'Sara',
  'Dustin',
  'Paul',
  'Angela',
  'Tyler',
  'Scott',
  'Katherine',
  'Andrea',
  'Gregory',
  'Erica',
  'Mary',
  'Travis',
  'Lisa',
  'Kenneth',
  'Bryan',
  'Lindsey',
  'Kristen',
  'Jose',
  'Alexander',
  'Jesse',
  'Katie',
  'Lindsay',
  'Shannon',
  'Vanessa',
  'Courtney',
  'Christine',
  'Alicia',
  'Cody',
  'Allison',
  'Bradley',
  'Samuel',
  'Shawn',
  'April',
  'Derek',
  'Kathryn',
  'Kristin',
  'Chad',
  'Jenna',
  'Tara',
  'Maria',
  'Krystal',
  'Jared',
  'Anna',
  'Edward',
  'Julie',
  'Peter',
  'Holly',
  'Marcus',
  'Kristina',
  'Natalie',
  'Jordan',
  'Victoria',
  'Jacqueline',
  'Corey',
  'Keith',
  'Monica',
  'Juan',
  'Donald',
  'Cassandra',
  'Meghan',
  'Joel',
  'Shane',
  'Phillip',
  'Patricia',
  'Brett',
  'Ronald',
  'Catherine',
  'George',
  'Antonio',
  'Cynthia',
  'Stacy',
  'Kathleen',
  'Raymond',
  'Carlos',
  'Brandi',
  'Douglas',
  'Nathaniel',
  'Ian',
  'Craig',
  'Brandy',
  'Alex',
  'Valerie',
  'Veronica',
  'Cory',
  'Whitney',
  'Gary',
  'Derrick',
  'Philip',
  'Luis',
  'Diana',
  'Chelsea',
  'Leslie',
  'Caitlin',
  'Leah',
  'Natasha',
  'Erika',
  'Casey',
  'Latoya',
  'Erik',
  'Dana',
  'Victor',
  'Brent',
  'Dominique',
  'Frank',
  'Brittney',
  'Evan',
  'Gabriel',
  'Julia',
  'Candice',
  'Karen',
  'Melanie',
  'Adrian',
  'Stacey',
  'Margaret',
  'Sheena',
  'Wesley',
  'Vincent',
  'Alexandra',
  'Katrina',
  'Bethany',
  'Nichole',
  'Larry',
  'Jeffery',
  'Curtis',
  'Carrie',
  'Todd',
  'Blake',
  'Christian',
  'Randy',
  'Dennis',
  'Alison',
  'Trevor',
  'Seth',
  'Kara',
  'Joanna',
  'Rachael',
  'Luke',
  'Felicia',
  'Brooke',
  'Austin',
  'Candace',
  'Jasmine',
  'Jesus',
  'Alan',
  'Susan',
  'Sandra',
  'Tracy',
  'Kayla',
  'Nancy',
  'Tina',
  'Krystle',
  'Russell',
  'Jeremiah',
  'Carl',
  'Miguel',
  'Tony',
  'Alexis',
  'Gina',
  'Jillian',
  'Pamela',
  'Mitchell',
  'Hannah',
  'Renee',
  'Denise',
  'Molly',
  'Jerry',
  'Misty',
  'Mario',
  'Johnathan',
  'Jaclyn',
  'Brenda',
  'Terry',
  'Lacey',
  'Shaun',
  'Devin',
  'Heidi',
  'Troy',
  'Lucas',
  'Desiree',
  'Jorge',
  'Andre',
  'Morgan',
  'Drew',
  'Sabrina',
  'Miranda',
  'Alyssa',
  'Alisha',
  'Teresa',
  'Johnny',
  'Meagan',
  'Allen',
  'Krista',
  'Marc',
  'Tabitha',
  'Lance',
  'Ricardo',
  'Martin',
  'Chase',
  'Theresa',
  'Melinda',
  'Monique',
  'Tanya',
  'Linda',
  'Kristopher',
  'Bobby',
  'Caleb',
  'Ashlee',
  'Kelli',
  'Henry',
  'Garrett',
  'Mallory',
  'Jill',
  'Jonathon',
  'Kristy',
  'Anne',
  'Francisco',
  'Danny',
  'Robin',
  'Lee',
  'Tamara',
  'Manuel',
  'Meredith',
  'Colleen',
  'Lawrence',
  'Christy',
  'Ricky',
  'Randall',
  'Marissa',
  'Ross',
  'Mathew',
  'Jimmy',
  'Abigail',
  'Kendra',
  'Carolyn',
  'Billy',
  'Deanna',
  'Jenny',
  'Jon',
  'Albert',
  'Taylor',
  'Lori',
  'Rebekah',
  'Cameron',
  'Ebony',
  'Wendy',
  'Angel',
  'Micheal',
  'Kristi',
  'Caroline',
  'Colin',
  'Dawn',
  'Kari',
  'Clayton',
  'Arthur',
  'Roger',
  'Roberto',
  'Priscilla',
  'Darren',
  'Kelsey',
  'Clinton',
  'Walter',
  'Louis',
  'Barbara',
  'Isaac',
  'Cassie',
  'Grant',
  'Cristina',
  'Tonya',
  'Rodney',
  'Bridget',
  'Joe',
  'Cindy',
  'Oscar',
  'Willie',
  'Maurice',
  'Jaime',
  'Angelica',
  'Sharon',
  'Julian',
  'Jack',
  'Jay',
  'Calvin',
  'Marie',
  'Hector',
  'Kate',
  'Adrienne',
  'Tasha',
  'Michele',
  'Ana',
  'Stefanie',
  'Cara',
  'Alejandro',
  'Ruben',
  'Gerald',
  'Audrey',
  'Kristine',
  'Ann',
  'Shana',
  'Javier',
  'Katelyn',
  'Brianna',
  'Bruce',
  'Deborah',
  'Claudia',
  'Carla',
  'Wayne',
  'Roy',
  'Virginia',
  'Haley',
  'Brendan',
  'Janelle',
  'Jacquelyn',
  'Beth',
  'Edwin',
  'Dylan',
  'Dominic',
  'Latasha',
  'Darrell',
  'Geoffrey',
  'Savannah',
  'Reginald',
  'Carly',
  'Fernando',
  'Ashleigh',
  'Aimee',
  'Regina',
  'Mandy',
  'Sergio',
  'Rafael',
  'Pedro',
  'Janet',
  'Kaitlin',
  'Frederick',
  'Cheryl',
  'Autumn',
  'Tyrone',
  'Martha',
  'Omar',
  'Lydia',
  'Jerome',
  'Theodore',
  'Abby',
  'Neil',
  'Shawna',
  'Sierra',
  'Nina',
  'Tammy',
  'Nikki',
  'Terrance',
  'Donna',
  'Claire',
  'Cole',
  'Trisha',
  'Bonnie',
  'Diane',
  'Summer',
  'Carmen',
  'Mayra',
  'Jermaine',
  'Eddie',
  'Micah',
  'Marvin',
  'Levi',
  'Emmanuel',
  'Brad',
  'Taryn',
  'Toni',
  'Jessie',
  'Evelyn',
  'Darryl',
  'Ronnie',
  'Joy',
  'Adriana',
  'Ruth',
  'Mindy',
  'Spencer',
  'Noah',
  'Raul',
  'Suzanne',
  'Sophia',
  'Dale',
  'Jodi',
  'Christie',
  'Raquel',
  'Naomi',
  'Kellie',
  'Ernest',
  'Jake',
  'Grace',
  'Tristan',
  'Shanna',
  'Hilary',
  'Eduardo',
  'Ivan',
  'Hillary',
  'Yolanda',
  'Alberto',
  'Andres',
  'Olivia',
  'FRndo',
  'Paula',
  'Amelia',
  'Sheila',
  'Rosa',
  'Robyn',
  'Kurt',
  'Dane',
  'Glenn',
  'Nicolas',
  'Gloria',
  'Eugene',
  'Logan',
  'Steve',
  'Ramon',
  'Bryce',
  'Tommy',
  'Preston',
  'Keri',
  'Devon',
  'Alana',
  'Marisa',
  'Melody',
  'Rose',
  'Barry',
  'Marco',
  'Karl',
  'Daisy',
  'Leonard',
  'Randi',
  'Maggie',
  'Charlotte',
  'Emma',
  'Terrence',
  'Justine',
  'Britney',
  'Lacy',
  'Jeanette',
  'Francis',
  'Tyson',
  'Elise',
  'Sylvia',
  'Rachelle',
  'Stanley',
  'Debra',
  'Brady',
  'Charity',
  'Hope',
  'Melvin',
  'Johanna',
  'Karla',
  'Jarrod',
  'Charlene',
  'Gabrielle',
  'Cesar',
  'Clifford',
  'Byron',
  'Terrell',
  'Sonia',
  'Julio',
  'Stacie',
  'Shelby',
  'Shelly',
  'Edgar',
  'Roxanne',
  'Dwayne',
  'Kaitlyn',
  'Kasey',
  'Jocelyn',
  'Alexandria',
  'Harold',
  'Esther',
  'Kerri',
  'Ellen',
  'Abraham',
  'Cedric',
  'Carol',
  'Katharine',
  'Shauna',
  'Frances',
  'Antoine',
  'Tabatha',
  'Annie',
  'Erick',
  'Alissa',
  'Sherry',
  'Chelsey',
  'Franklin',
  'Branden',
  'Helen',
  'Traci',
  'Lorenzo',
  'Dean',
  'Sonya',
  'Briana',
  'Angelina',
  'Trista',
  'Bianca',
  'Leticia',
  'Tia',
  'Kristie',
  'Stuart',
  'Laurie',
  'Harry',
  'Leigh',
  'Elisabeth',
  'Alfredo',
  'Aubrey',
  'Ray',
  'Arturo',
  'Joey',
  'Kelley',
  'Max',
  'Andy',
  'Latisha',
  'Johnathon',
  'India',
  'Eva',
  'Ralph',
  'Yvonne',
  'Warren',
  'Kirsten',
  'Miriam',
  'Kelvin',
  'Lorena',
  'Staci',
  'Anita',
  'Rene',
  'Cortney',
  'Orlando',
  'Carissa',
  'Jade',
  'Camille',
  'Leon',
  'Paige',
  'Marcos',
  'Elena',
  'Brianne',
  'Dorothy',
  'Marshall',
  'Daryl',
  'Colby',
  'Terri',
  'Gabriela',
  'Brock',
  'Gerardo',
  'Jane',
  'Nelson',
  'Tamika',
  'Alvin',
  'Chasity',
  'Trent',
  'Jana',
  'Enrique',
  'Tracey',
  'Antoinette',
  'Jami',
  'Earl',
  'Gilbert',
  'Damien',
  'Janice',
  'Christa',
  'Tessa',
  'Kirk',
  'Yvette',
  'Elijah',
  'Howard',
  'Elisa',
  'Desmond',
  'Clarence',
  'Alfred',
  'Darnell',
  'Breanna',
  'Kerry',
  'Nickolas',
  'Maureen',
  'Karina',
  'Roderick',
  'Rochelle',
  'Rhonda',
  'Keisha',
  'Irene',
  'Ethan',
  'Alice',
  'Allyson',
  'Hayley',
  'Trenton',
  'Beau',
  'Elaine',
  'Demetrius',
  'Cecilia',
  'Annette',
  'Brandie',
  'Katy',
  'Tricia',
  'Bernard',
  'Wade',
  'Chance',
  'Bryant',
  'Zachery',
  'Clifton',
  'Julianne',
  'Angelo',
  'Elyse',
  'Lyndsey',
  'Clarissa',
  'Meaghan',
  'Tanisha',
  'Ernesto',
  'Isaiah',
  'Xavier',
  'Clint',
  'Jamal',
  'Kathy',
  'Salvador',
  'Jena',
  'Marisol',
  'Darius',
  'Guadalupe',
  'Chris',
  'Patrice',
  'Jenifer',
  'Lynn',
  'Landon',
  'Brenton',
  'Sandy',
  'Jasmin',
  'Ariel',
  'Sasha',
  'Juanita',
  'Israel',
  'Ericka',
  'Quentin',
  'Jayme',
  'Damon',
  'Heath',
  'Kira',
  'Ruby',
  'Rita',
  'Tiara',
  'Jackie',
  'Jennie',
  'Collin',
  'Lakeisha',
  'Kenny',
  'Norman',
  'Leanne',
  'Hollie',
  'Destiny',
  'Shelley',
  'Amie',
  'Callie',
  'Hunter',
  'Duane',
  'Sally',
  'Serena',
  'Lesley',
  'Connie',
  'Dallas',
  'Simon',
  'Neal',
  'Laurel',
  'Eileen',
  'Lewis',
  'Bobbie',
  'Faith',
  'Brittani',
  'Shayla',
  'Eli',
  'Judith',
  'Terence',
  'Ciara',
  'Charlie',
  'Alyson',
  'Vernon',
  'Alma',
  'Quinton',
  'Nora',
  'Lillian',
  'Leroy',
  'Joyce',
  'Chrystal',
  'Marquita',
  'Lamar',
  'Ashlie',
  'Kent',
  'Emanuel',
  'Joanne',
  'Gavin',
  'Yesenia',
  'Perry',
  'Marilyn',
  'Graham',
  'Constance',
  'Lena',
  'Allan',
  'Juliana',
  'Jayson',
  'Shari',
  'Nadia',
  'Tanner',
  'Isabel',
  'Becky',
  'Rudy',
  'Blair',
  'Christen',
  'Rosemary',
  'Marlon',
  'Glen',
  'Genevieve',
  'Damian',
  'Michaela',
  'Shayna',
  'Marquis',
  'Fredrick',
  'Celeste',
  'Bret',
  'Betty',
  'Kurtis',
  'Rickey',
  'Dwight',
  'Rory',
  'Mia',
  'Josiah',
  'Norma',
  'Bridgette',
  'Shirley',
  'Sherri',
  'Noelle',
  'Chantel',
  'Alisa',
  'Zachariah',
  'Jody',
  'Christin',
  'Julius',
  'Gordon',
  'Latonya',
  'Lara',
  'Lucy',
  'Jarrett',
  'Elisha',
  'Deandre',
  'Audra',
  'Beverly',
  'Felix',
  'Alejandra',
  'Nolan',
  'Tiffani',
  'Lonnie',
  'Don',
  'Darlene',
  'Rodolfo',
  'Terra',
  'Sheri',
  'Iris',
  'Maxwell',
  'Kendall',
  'Ashly',
  'Kendrick',
  'Jean',
  'Jarvis',
  'Fred',
  'Tierra',
  'Abel',
  'Pablo',
  'Maribel',
  'Donovan',
  'Stephan',
  'Judy',
  'Elliott',
  'Tyrell',
  'Chanel',
  'Miles',
  'Fabian',
  'Alfonso',
  'Cierra',
  'Mason',
  'Larissa',
  'Elliot',
  'Brenna',
  'Bradford',
  'Kristal',
  'Gustavo',
  'Gretchen',
  'Derick',
  'Jarred',
  'Pierre',
  'Lloyd',
  'Jolene',
  'Marlene',
  'Leo',
  'Jamar',
  'Dianna',
  'Noel',
  'Angie',
  'Tatiana',
  'Rick',
  'Leann',
  'Corinne',
  'Sydney',
  'Belinda',
  'Lora',
  'Mackenzie',
  'Herbert',
  'Guillermo',
  'Tameka',
  'Elias',
  'Janine',
  'Ben',
  'Stefan',
  'Josephine',
  'Dominick',
  'Jameson',
  'Bobbi',
  'Blanca',
  'Josue',
  'Esmeralda',
  'Darin',
  'Ashely',
  'Clay',
  'Cassidy',
  'Roland',
  'Ismael',
  'Harrison',
  'Lorraine',
  'Owen',
  'Daniela',
  'Rocky',
  'Marisela',
  'Saul',
  'Kory',
  'Dexter',
  'Chandra',
  'Gwendolyn',
  'Francesca',
  'Alaina',
  'Mandi',
  'Fallon',
  'Celia',
  'Vivian',
  'Rolando',
  'Raven',
  'Lionel',
  'Carolina',
  'Tania',
  'Joann',
  'Casandra',
  'Betsy',
  'Tracie',
  'Dante',
  'Trey',
  'Margarita',
  'Skyler',
  'Sade',
  'Lyndsay',
  'Jacklyn',
  'Marina',
  'Rogelio',
  'Racheal',
  'Mollie',
  'Liliana',
  'Maegan',
  'Felipe',
  'Malcolm',
  'Santana',
  'Anastasia',
  'Madeline',
  'Breanne',
  'Tiffanie',
  'Dillon',
  'Melisa',
  'Darrin',
  'Carlton',
  'Cornelius',
  'Precious',
  'Ivy',
  'Lea',
  'Susana',
  'Loren',
  'Jeff',
  'Chiquita',
  'Teri',
  'Tera',
  'Caitlyn',
  'Hailey',
  'Donte',
  'Oliver',
  'Natalia',
  'Cherie',
  'Lakisha',
  'Karissa',
  'Jeannette',
  'Ariana',
  'Lucia',
  'Jerrod',
  'Kassandra',
  'Guy',
  'Milton',
  'Micaela',
  'Krystina',
  'Esteban',
  'Gilberto',
  'Chelsie',
  'Antwan',
  'Cathy',
  'Ty',
  'Shante',
  'Roman',
  'Kylie',
  'Mercedes',
  'Dena',
  'Christi',
  'Latrice',
  'Kellen',
  'Freddie',
  'Clara',
  'Rosanna',
  'Demarcus',
  'Domonique',
  'Alvaro',
  'Shaina',
  'Nathanael',
  'Kacie',
  'Jodie',
  'Dusty',
  'Sidney',
  'Adrianne',
  'Mike',
  'Chloe',
  'Alecia',
  'Sam',
  'Rocio',
  'Kim',
  'Arlene',
  'Antonia',
  'Jamaal',
  'Shantel',
  'Deidre',
  'Salvatore',
  'Kimberley',
  'Gerard',
  'Gene',
  'Weston',
  'Diego',
  'Tasia',
  'Mariah',
  'Jimmie',
  'Zackary',
  'Hugo',
  'Leanna',
  'Lacie',
  'Donnie',
  'Aisha',
  'Marianne',
  'Lana',
  'Kyla',
  'Ginger',
  'Tiana',
  'Lashonda',
  'Dayna',
  'Marcia',
  'Luz',
  'Janna',
  'Riley',
  'Desirae',
  'Billie',
  'Zane',
  'Johnnie',
  'Greg',
  'Angelique',
  'Kali',
  'Silvia',
  'Asia',
  'Quincy',
  'Catrina',
  'Rusty',
  'Frankie',
  'Athena',
  'Randolph',
  'Sheldon',
  'Maricela',
  'Tomas',
  'Toby',
  'Nadine',
  'Keshia',
  'Tosha',
  'Maranda',
  'Lester',
  'Brendon',
  'Korey',
  'Lynette',
  'Joan',
  'Justina',
  'Moses',
  'Dominque',
  'Abbey',
  'Kristyn',
  'Dewayne',
  'Alonzo',
  'Laci',
  'Cori',
  'Debbie',
  'Zackery',
  'Parker',
  'Forrest',
  'Blaine',
  'Trina',
  'Herman',
  'Selena',
  'Myra',
  'Joni',
  'Bailey',
  'Julianna',
  'Edith',
  'Octavia',
  'Bryon',
  'Arielle',
  'Giovanni',
  'Jarod',
  'Floyd',
  'Sonja',
  'Kody',
  'Jamel',
  'Jeannie',
  'Elissa',
  'Leonardo',
  'Sadie',
  'Madison',
  'Kandice',
  'Janie',
  'Reid',
  'Alanna',
  'Linsey',
  'Moises',
  'Darcy',
  'Britni',
  'Beatrice',
  'Everett',
  'Corina',
  'Brooks',
  'Tori',
  'Ramiro',
  'Lamont',
  'Kenya',
  'Cheri',
  'Alec',
  'Roberta',
  'Jeanne',
  'Jackson',
  'Maritza',
  'Loretta',
  'Shameka',
  'Sebastian',
  'Ryne',
  'Scotty',
  'Emilie',
  'Ladonna',
  'Stewart',
  'Dina',
  'Clark',
  'Chadwick',
  'Araceli',
  'Ali',
  'Kareem',
  'Janette',
  'Savanna',
  'Reuben',
  'Nakia',
  'Martina',
  'Wilson',
  'Kristian',
  'Daphne',
  'Clyde',
  'Braden',
  'Sterling',
  'Cari',
  'Marsha',
  'Deidra',
  'Bridgett',
  'Rhiannon',
  'Kristofer',
  'Keenan',
  'Joelle',
  'Colt',
  'Celina',
  'Deana',
  'Penny',
  'Georgia',
  'Eleanor',
  'Shanika',
  'Daniella',
  'Bernadette',
  'Valarie',
  'Tarah',
  'Princess',
  'Noemi',
  'Maura',
  'Maryann',
  'Jonah',
  'Santiago',
  'Jamison',
  'Cecil',
  'Ted',
  'Selina',
  'Dan',
  'Reynaldo',
  'Myron',
  'Sofia',
  'Doris',
  'Deangelo',
  'Ashli',
  'Randal',
  'Noe',
  'Jess',
  'Holli',
  'Chester',
  'Rex',
  'Meghann',
  'Janell',
  'Garret',
  'Marjorie',
  'Avery',
  'Jazmin',
  'Christal',
  'Freddy',
  'Carson',
  'Raphael',
  'Quintin',
  'Lakesha',
  'Gladys',
  'Lizette',
  'Latosha',
  'Carina',
  'Nick',
  'Joaquin',
  'Garry',
  'Erich',
  'Brennan',
  'Valencia',
  'Dion',
  'Peggy',
  'Nicolette',
  'Leeann',
  'Maya',
  'Lakeshia',
  'Deon',
  'Ciera',
  'Tami',
  'Olga',
  'Josh',
  'Cristal',
  'Brice',
  'Beatriz',
  'Wendell',
  'Jenelle',
  'Efrain',
  'Lyle',
  'Krysta',
  'Solomon',
  'Jordon',
  'Colette',
  'Alesha',
  'Sammy',
  'Rigoberto',
  'Liza',
  'Kristan',
  'Eliza',
  'Lily',
  'Hanna',
  'Candy',
  'Adan',
  'Renae',
  'Marcella',
  'Lynsey',
  'Chastity',
  'Pauline',
  'Shamika',
  'Humberto',
  'Eboni',
  'Aron',
  'Adrianna',
  'Sheree',
  'Shanta',
  'Marla',
  'Delilah',
  'Susanna',
  'Kaylee',
  'Kassie',
  'Felisha',
  'Aileen',
  'Geneva',
  'Wanda',
  'Siobhan',
  'Shea',
  'Kimberlee',
  'Gillian',
  'Roxana',
  'Gabriella',
  'Chantelle',
  'Candis',
  'Abbie',
  'Jeanine',
  'Harvey',
  'Dora',
  'Barrett',
  'Amos',
  'Marlena',
  'Marcie',
  'Lucinda',
  'Reed',
  'Giselle',
  'Griselda',
  'Ashton',
  'Alycia',
  'Talia',
  'Magen',
  'Anton',
  'Vicente',
  'Hugh',
  'Harley',
  'Cristy',
  'Valeria',
  'Thaddeus',
  'Simone',
  'Kylee',
  'Kirby',
  'Dorian',
  'Andria',
  'Marques',
  'Kala',
  'Kacey',
  'Fatima',
  'Conrad',
  'Dara',
  'Winston',
  'Robbie',
  'Kiel',
  'Emilio',
  'Cora',
  'Sharonda',
  'Josie',
  'Marci',
  'Laquita',
  'Kia',
  'Danelle',
  'Leila',
  'Chantal',
  'Tess',
  'Tamra',
  'Nathanial',
  'Francine',
  'Mauricio',
  'Janae',
  'Donnell',
  'Arron',
  'Stevie',
  'Ramona',
  'Royce',
  'Kourtney',
  'Kathrine',
  'Shanda',
  'Myles',
  'Kaci',
  'Jerod',
  'Ingrid',
  'Bradly',
  'Benny',
  'Malinda',
  'Kati',
  'Irma',
  'Glenda',
  'Brittni',
  'Mariana',
  'Kayleigh',
  'Jairo',
  'Wyatt',
  'Rikki',
  'Britany',
  'Viviana',
  'Jim',
  'Durell',
  'Clare',
  'Bryson',
  'Aurora',
  'Vicki',
  'Venessa',
  'Alton',
  'Jerrell',
  'Casie',
  'Kori',
  'Keegan',
  'Sophie',
  'Perla',
  'Paris',
  'Misti',
  'Chaz',
  'Otis',
  'Morris',
  'Mara',
  'Jeri',
  'Jeanna',
  'Deshawn',
  'Will',
  'Tanesha',
  'Sherrie',
  'Marcel',
  'Demario',
  'Sonny',
  'Lynda',
  'Joesph',
  'Elvis',
  'Yadira',
  'Marian',
  'Jovan',
  'Edna',
  'Dolores',
  'Conor',
  'Alexa',
  'Sheryl',
  'Lissette',
  'Kaleb',
  'Ignacio',
  'Emilee',
  'Annmarie',
  'Vicky',
  'Tyree',
  'Cary',
  'Tyra',
  'Sherman',
  'Nathalie',
  'Lukas',
  'Karin',
  'Jaimie',
  'Corrie',
  'Reyna',
  'Prince',
  'Nigel',
  'Lourdes',
  'Louise',
  'Jonas',
  'Hallie',
  'Alyse',
  'Wilfredo',
  'Sylvester',
  'Marcy',
  'Jesica',
  'Gail',
  'Zoe',
  'Tabetha',
  'Rena',
  'Arnold',
  'Elsa',
  'Cherish',
  'Brody',
  'Markus',
  'Elaina',
  'Deirdre',
  'Cortez',
  'Stacia',
  'Rosalinda',
  'Deandra',
  'Roxanna',
  'Kami',
  'Davon',
  'Cathleen',
  'Claude',
  'Ahmad',
  'Tonia',
  'Richelle',
  'Kandace',
  'Danyelle',
  'Willis',
  'Jerad',
  'Helena',
  'Danica',
  'Cale',
  'Rosemarie',
  'Meggan',
  'Janel',
  'Chana',
  'Brittny',
  'Ashlea',
  'Antwon',
  'Yasmin',
  'Nikolas',
  'Mellissa',
  'Chfrine',
  'Alina',
  'Rodrigo',
  'Nikole',
  'Mckenzie',
  'Leonel',
  'Kaley',
  'Jessi',
  'Delia',
  'Melina',
  'Hilda',
  'Alysha',
  'Pete',
  'Niki',
  'Davis',
  'Cristian',
  'Waylon',
  'Wallace',
  'Keely',
  'Graciela',
  'Demetria',
  'Cecelia',
  'Issac',
  'Felecia',
  'Ami',
  'Tom',
  'Shavon',
  'Paola',
  'Lane',
  'June',
  'Hans',
  'Earnest',
  'Cheyenne',
  'Sondra',
  'Sherita',
  'Jasper',
  'Coty',
  'Candi',
  'Santos',
  'Ron',
  'Jace',
  'Darla',
  'Dannielle',
  'Carley',
  'Brandan',
  'Bill',
  'Tory',
  'Skylar',
  'Marta',
  'Cristin',
  'Connor',
  'Carter',
  'Carey',
  'Wendi',
  'Shasta',
  'Shaquita',
  'Maira',
  'Jazmine',
  'Edmund',
  'Adriane',
  'Tana',
  'Latoria',
  'Kyra',
  'Krysten',
  'Jada',
  'Derik',
  'Darrel',
  'Amir',
  'Shanita',
  'Rebeca',
  'Monika',
  'Mai',
  'Luther',
  'Jo',
  'Georgina',
  'Gena',
  'Ezra',
  'Quinn',
  'Portia',
  'Mickey',
  'Magan',
  'Lisette',
  'Josef',
  'Colton',
  'Brittanie',
  'Malissa',
  'Krystin',
  'Jefferson',
  'Rashad',
  'Kiley',
  'Kerrie',
  'Stephany',
  'Lia',
  'Katheryn',
  'Juliet',
  'Gregg',
  'Brynn',
  'Rosalyn',
  'Marion',
  'Katelin',
  'Jeana',
  'Cassondra',
  'Agustin',
  'Tyesha',
  'Leland',
  'Damion',
  'Sharita',
  'Pearl',
  'Shara',
  'Matt',
  'Duncan',
  'Mari',
  'Latanya',
  'Karly',
  'Cathryn',
  'Alena',
  'Ada',
  'Vance',
  'Susie',
  'Sunny',
  'Nikita',
  'Corrine',
  'Brook',
  'Bertha',
  'Mitchel',
  'Ira',
  'Carlie',
  'Brant',
  'Bennett',
  'Violeta',
  'Tyrel',
  'Rosalie',
  'Markita',
  'Akeem',
  'Aja',
  'Stefani',
  'Jenni',
  'Galen',
  'Deena',
  'Shavonne',
  'Robby',
  'Kirstin',
  'Kasie',
  'Eunice',
  'Brigitte',
  'Tisha',
  'Shena',
  'Shayne',
  'Rudolph',
  'Roosevelt',
  'Mikel',
  'Kacy',
  'Breann',
  'Salina',
  'Rodrick',
  'Mariel',
  'Kelsie',
  'Karrie',
  'Jessika',
  'Jarrell',
  'Curt',
  'Stella',
  'Shira',
  'Rhett',
  'Marty',
  'Iesha',
  'Devan',
  'Brain',
  'Tammie',
  'Shantell',
  'Mohammad',
  'Kiana',
  'Jaqueline',
  'Caryn',
  'Samatha',
  'Nia',
  'Mona',
  'Leilani',
  'Lashanda',
  'Javon',
  'Ida'
}

cfg.random_last_names = {

  'Smith',
  'Johnson',
  'Williams',
  'Brown',
  'Jones',
  'Garcia',
  'Miller',
  'Davis',
  'Rodriguez',
  'Martinez',
  'Hernandez',
  'Lopez',
  'Gonzalez',
  'Wilson',
  'Anderson',
  'Thomas',
  'Taylor',
  'Moore',
  'Jackson',
  'Martin',
  'Lee',
  'Perez',
  'Thompson',
  'White',
  'Harris',
  'Sanchez',
  'Clark',
  'Ramirez',
  'Lewis',
  'Robinson',
  'Walker',
  'Young',
  'Allen',
  'King',
  'Wright',
  'Scott',
  'Torres',
  'Nguyen',
  'Hill',
  'Flores',
  'Green',
  'Adams',
  'Nelson',
  'Baker',
  'Hall',
  'Rivera',
  'Campbell',
  'Mitchell',
  'Carter',
  'Roberts',
  'Gomez',
  'Phillips',
  'Evans',
  'Turner',
  'Diaz',
  'Parker',
  'Cruz',
  'Edwards',
  'Collins',
  'Reyes',
  'Stewart',
  'Morris',
  'Morales',
  'Murphy',
  'Cook',
  'Rogers',
  'Gutierrez',
  'Ortiz',
  'Morgan',
  'Cooper',
  'Peterson',
  'Bailey',
  'Reed',
  'Kelly',
  'Howard',
  'Ramos',
  'Kim',
  'Cox',
  'Ward',
  'Richardson',
  'Watson',
  'Brooks',
  'Chavez',
  'Wood',
  'James',
  'Bennett',
  'Gray',
  'Mendoza',
  'Ruiz',
  'Hughes',
  'Price',
  'Alvarez',
  'Castillo',
  'Sanders',
  'Patel',
  'Myers',
  'Long',
  'Ross',
  'Foster',
  'Jimenez',
  'Powell',
  'Jenkins',
  'Perry',
  'Russell',
  'Sullivan',
  'Bell',
  'Coleman',
  'Butler',
  'Henderson',
  'Barnes',
  'Gonzales',
  'Fisher',
  'Vasquez',
  'Simmons',
  'Romero',
  'Jordan',
  'Patterson',
  'Alexander',
  'Hamilton',
  'Graham',
  'Reynolds',
  'Griffin',
  'Wallace',
  'Moreno',
  'West',
  'Cole',
  'Hayes',
  'Bryant',
  'Herrera',
  'Gibson',
  'Ellis',
  'Tran',
  'Medina',
  'Aguilar',
  'Stevens',
  'Murray',
  'Ford',
  'Castro',
  'Marshall',
  'Owens',
  'Harrison',
  'Fernandez',
  'Mcdonald',
  'Woods',
  'Washington',
  'Kennedy',
  'Wells',
  'Vargas',
  'Henry',
  'Chen',
  'Freeman',
  'Webb',
  'Tucker',
  'Guzman',
  'Burns',
  'Crawford',
  'Olson',
  'Simpson',
  'Porter',
  'Hunter',
  'Gordon',
  'Mendez',
  'Silva',
  'Shaw',
  'Snyder',
  'Mason',
  'Dixon',
  'Munoz',
  'Hunt',
  'Hicks',
  'Holmes',
  'Palmer',
  'Wagner',
  'Black',
  'Robertson',
  'Boyd',
  'Rose',
  'Stone',
  'Salazar',
  'Fox',
  'Warren',
  'Mills',
  'Meyer',
  'Rice',
  'Schmidt',
  'Garza',
  'Daniels',
  'Ferguson',
  'Nichols',
  'Stephens',
  'Soto',
  'Weaver',
  'Ryan',
  'Gardner',
  'Payne',
  'Grant',
  'Dunn',
  'Kelley',
  'Spencer',
  'Hawkins',
  'Arnold',
  'Pierce',
  'Vazquez',
  'Hansen',
  'Peters',
  'Santos',
  'Hart',
  'Bradley',
  'Knight',
  'Elliott',
  'Cunningham',
  'Duncan',
  'Armstrong',
  'Hudson',
  'Carroll',
  'Lane',
  'Riley',
  'Andrews',
  'Alvarado',
  'Ray',
  'Delgado',
  'Berry',
  'Perkins',
  'Hoffman',
  'Johnston',
  'Matthews',
  'Pena',
  'Richards',
  'Contreras',
  'Willis',
  'Carpenter',
  'Lawrence',
  'Sandoval',
  'Guerrero',
  'George',
  'Chapman',
  'Rios',
  'Estrada',
  'Ortega',
  'Watkins',
  'Greene',
  'Nunez',
  'Wheeler',
  'Valdez',
  'Harper',
  'Burke',
  'Larson',
  'Santiago',
  'Maldonado',
  'Morrison',
  'Franklin',
  'Carlson',
  'Austin',
  'Dominguez',
  'Carr',
  'Lawson',
  'Jacobs',
  'Obrien',
  'Lynch',
  'Singh',
  'Vega',
  'Bishop',
  'Montgomery',
  'Oliver',
  'Jensen',
  'Harvey',
  'Williamson',
  'Gilbert',
  'Dean',
  'Sims',
  'Espinoza',
  'Howell',
  'Li',
  'Wong',
  'Reid',
  'Hanson',
  'Le',
  'Mccoy',
  'Garrett',
  'Burton',
  'Fuller',
  'Wang',
  'Weber',
  'Welch',
  'Rojas',
  'Lucas',
  'Marquez',
  'Fields',
  'Park',
  'Yang',
  'Little',
  'Banks',
  'Padilla',
  'Day',
  'Walsh',
  'Bowman',
  'Schultz',
  'Luna',
  'Fowler',
  'Mejia',
  'Davidson',
  'Acosta',
  'Brewer',
  'May',
  'Holland',
  'Juarez',
  'Newman',
  'Pearson',
  'Curtis',
  'Cortez',
  'Douglas',
  'Schneider',
  'Joseph',
  'Barrett',
  'Navarro',
  'Figueroa',
  'Keller',
  'Avila',
  'Wade',
  'Molina',
  'Stanley',
  'Hopkins',
  'Campos',
  'Barnett',
  'Bates',
  'Chambers',
  'Caldwell',
  'Beck',
  'Lambert',
  'Miranda',
  'Byrd',
  'Craig',
  'Ayala',
  'Lowe',
  'Frazier',
  'Powers',
  'Neal',
  'Leonard',
  'Gregory',
  'Carrillo',
  'Sutton',
  'Fleming',
  'Rhodes',
  'Shelton',
  'Schwartz',
  'Norris',
  'Jennings',
  'Watts',
  'Duran',
  'Walters',
  'Cohen',
  'Mcdaniel',
  'Moran',
  'Parks',
  'Steele',
  'Vaughn',
  'Becker',
  'Holt',
  'Deleon',
  'Barker',
  'Terry',
  'Hale',
  'Leon',
  'Hail',
  'Benson',
  'Haynes',
  'Horton',
  'Miles',
  'Lyons',
  'Pham',
  'Graves',
  'Bush',
  'Thornton',
  'Wolfe',
  'Warner',
  'Cabrera',
  'Mckinney',
  'Mann',
  'Zimmerman',
  'Dawson',
  'Lara',
  'Fletcher',
  'Page',
  'Mccarthy',
  'Love',
  'Robles',
  'Cervantes',
  'Solis',
  'Erickson',
  'Reeves',
  'Chang',
  'Klein',
  'Salinas',
  'Fuentes',
  'Baldwin',
  'Daniel',
  'Simon',
  'Velasquez',
  'Hardy',
  'Higgins',
  'Aguirre',
  'Lin',
  'Cummings',
  'Chandler',
  'Sharp',
  'Barber',
  'Bowen',
  'Ochoa',
  'Dennis',
  'Robbins',
  'Liu',
  'Ramsey',
  'Francis',
  'Griffith',
  'Paul',
  'Blair',
  'Oconnor',
  'Cardenas',
  'Pacheco',
  'Cross',
  'Calderon',
  'Quinn',
  'Moss',
  'Swanson',
  'Chan',
  'Rivas',
  'Khan',
  'Rodgers',
  'Serrano',
  'Fitzgerald',
  'Rosales',
  'Stevenson',
  'Christensen',
  'Manning',
  'Gill',
  'Curry',
  'Mclaughlin',
  'Harmon',
  'Mcgee',
  'Gross',
  'Doyle',
  'Garner',
  'Newton',
  'Burgess',
  'Reese',
  'Walton',
  'Blake',
  'Trujillo',
  'Adkins',
  'Brady',
  'Goodman',
  'Roman',
  'Webster',
  'Goodwin',
  'Fischer',
  'Huang',
  'Potter',
  'Delacruz',
  'Montoya',
  'Todd',
  'Wu',
  'Hines',
  'Mullins',
  'Castaneda',
  'Malone',
  'Cannon',
  'Tate',
  'Mack',
  'Sherman',
  'Hubbard',
  'Hodges',
  'Zhang',
  'Guerra',
  'Wolf',
  'Valencia',
  'Franco',
  'Saunders',
  'Rowe',
  'Gallagher',
  'Farmer',
  'Hammond',
  'Hampton',
  'Townsend',
  'Ingram',
  'Wise',
  'Gallegos',
  'Clarke',
  'Barton',
  'Schroeder',
  'Maxwell',
  'Waters',
  'Logan',
  'Camacho',
  'Strickland',
  'Norman',
  'Person',
  'Colon',
  'Parsons',
  'Frank',
  'Harrington',
  'Glover',
  'Osborne',
  'Buchanan',
  'Casey',
  'Floyd',
  'Patton',
  'Ibarra',
  'Ball',
  'Tyler',
  'Suarez',
  'Bowers',
  'Orozco',
  'Salas',
  'Cobb',
  'Gibbs',
  'Andrade',
  'Bauer',
  'Conner',
  'Moody',
  'Escobar',
  'Mcguire',
  'Lloyd',
  'Mueller',
  'Hartman',
  'French',
  'Kramer',
  'Mcbride',
  'Pope',
  'Lindsey',
  'Velazquez',
  'Norton',
  'Mccormick',
  'Sparks',
  'Flynn',
  'Yates',
  'Hogan',
  'Marsh',
  'Macias',
  'Villanueva',
  'Zamora',
  'Pratt',
  'Stokes',
  'Owen',
  'Ballard',
  'Lang',
  'Brock',
  'Villarreal',
  'Charles',
  'Drake',
  'Barrera',
  'Cain',
  'Patrick',
  'Pineda',
  'Burnett',
  'Mercado',
  'Santana',
  'Shepherd',
  'Bautista',
  'Ali',
  'Shaffer',
  'Lamb',
  'Trevino',
  'Mckenzie',
  'Hess',
  'Beil',
  'Olsen',
  'Cochran',
  'Morton',
  'Nash',
  'Wilkins',
  'Petersen',
  'Briggs',
  'Shah',
  'Roth',
  'Nicholson',
  'Holloway',
  'Lozano',
  'Flowers',
  'Rangel',
  'Hoover',
  'Arias',
  'Short',
  'Mora',
  'Valenzuela',
  'Bryan',
  'Meyers',
  'Weiss',
  'Underwood',
  'Bass',
  'Greer',
  'Summers',
  'Houston',
  'Carson',
  'Morrow',
  'Clayton',
  'Whitaker',
  'Decker',
  'Yoder',
  'Collier',
  'Zuniga',
  'Carey',
  'Wilcox',
  'Melendez',
  'Poole',
  'Roberson',
  'Larsen',
  'Conley',
  'Davenport',
  'Copeland',
  'Massey',
  'Lam',
  'Huff',
  'Rocha',
  'Cameron',
  'Jefferson',
  'Hood',
  'Monroe',
  'Anthony',
  'Pittman',
  'Huynh',
  'Randall',
  'Singleton',
  'Kirk',
  'Combs',
  'Mathis',
  'Christian',
  'Skinner',
  'Bradford',
  'Richard',
  'Galvan',
  'Wall',
  'Boone',
  'Kirby',
  'Wilkinson',
  'Bridges',
  'Bruce',
  'Atkinson',
  'Velez',
  'Meza',
  'Roy',
  'Vincent',
  'York',
  'Hodge',
  'Villa',
  'Abbott',
  'Allison',
  'Tapia',
  'Gates',
  'Chase',
  'Sosa',
  'Sweeney',
  'Farrell',
  'Wyatt',
  'Dalton',
  'Horn',
  'Barron',
  'Phelps',
  'Yu',
  'Dickerson',
  'Heath',
  'Foley',
  'Atkins',
  'Mathews',
  'Bonilla',
  'Acevedo',
  'Benitez',
  'Zavala',
  'Hensley',
  'Glenn',
  'Cisneros',
  'Harrell',
  'Shields',
  'Rubio',
  'Choi',
  'Huffman',
  'Boyer',
  'Garrison',
  'Arroyo',
  'Bond',
  'Kane',
  'Hancock',
  'Callahan',
  'Dillon',
  'Cline',
  'Wiggins',
  'Grimes',
  'Arellano',
  'Melton',
  'Oneill',
  'Savage',
  'Ho',
  'Beltran',
  'Pitts',
  'Parrish',
  'Ponce',
  'Rich',
  'Booth',
  'Koch',
  'Golden',
  'Ware',
  'Brennan',
  'Mcdowell',
  'Marks',
  'Cantu',
  'Humphrey',
  'Baxter',
  'Sawyer',
  'Clay',
  'Tanner',
  'Hutchinson',
  'Kaur',
  'Berg',
  'Wiley',
  'Gilmore',
  'Russo',
  'Villegas',
  'Hobbs',
  'Keith',
  'Wilkerson',
  'Ahmed',
  'Beard',
  'Mcclain',
  'Montes',
  'Mata',
  'Rosario',
  'Vang',
  'Walter',
  'Henson',
  'Oneal',
  'Mosley',
  'Mcclure',
  'Beasley',
  'Stephenson',
  'Snow',
  'Huerta',
  'Preston',
  'Vance',
  'Barry',
  'Johns',
  'Eaton',
  'Blackwell',
  'Dyer',
  'Prince',
  'Macdonald',
  'Solomon',
  'Guevara',
  'Stafford',
  'English',
  'Hurst',
  'Woodard',
  'Cortes',
  'Shannon',
  'Kemp',
  'Nolan',
  'Mccullough',
  'Merritt',
  'Murillo',
  'Moon',
  'Salgado',
  'Strong',
  'Kline',
  'Cordova',
  'Barajas',
  'Roach',
  'Rosas',
  'Winters',
  'Jacobson',
  'Lester',
  'Knox',
  'Bullock',
  'Kerr',
  'Leach',
  'Meadows',
  'Davila',
  'Orr',
  'Whitehead',
  'Pruitt',
  'Kent',
  'Conway',
  'Mckee',
  'Barr',
  'David',
  'Dejesus',
  'Marin',
  'Berger',
  'Mcintyre',
  'Blankenship',
  'Gaines',
  'Palacios',
  'Cuevas',
  'Bartlett',
  'Durham',
  'Dorsey',
  'Mccall',
  'Odonnell',
  'Stein',
  'Browning',
  'Stout',
  'Lowery',
  'Sloan',
  'Mclean',
  'Hendricks',
  'Calhoun',
  'Sexton',
  'Chung',
  'Gentry',
  'Hull',
  'Duarte',
  'Ellison',
  'Nielsen',
  'Gillespie',
  'Buck',
  'Middleton',
  'Sellers',
  'Leblanc',
  'Esparza',
  'Hardin',
  'Bradshaw',
  'Mcintosh',
  'Howe',
  'Livingston',
  'Frost',
  'Glass',
  'Morse',
  'Knapp',
  'Herman',
  'Stark',
  'Bravo',
  'Noble',
  'Spears',
  'Weeks',
  'Corona',
  'Frederick',
  'Buckley',
  'Mcfarland',
  'Hebert',
  'Enriquez',
  'Hickman',
  'Quintero',
  'Randolph',
  'Schaefer',
  'Walls',
  'Trejo',
  'House',
  'Reilly',
  'Pennington',
  'Michael',
  'Conrad',
  'Giles',
  'Benjamin',
  'Crosby',
  'Fitzpatrick',
  'Donovan',
  'Mays',
  'Mahoney',
  'Valentine',
  'Raymond',
  'Medrano',
  'Hahn',
  'Mcmillan',
  'Small',
  'Bentley',
  'Felix',
  'Peck',
  'Lucero',
  'Boyle',
  'Hanna',
  'Pace',
  'Rush',
  'Hurley',
  'Harding',
  'Mcconnell',
  'Bernal',
  'Nava',
  'Ayers',
  'Everett',
  'Ventura',
  'Avery',
  'Pugh',
  'Mayer',
  'Bender',
  'Shepard',
  'Mcmahon',
  'Landry',
  'Case',
  'Sampson',
  'Moses',
  'Magana',
  'Blackburn',
  'Dunlap',
  'Gould',
  'Duffy',
  'Vaughan',
  'Herring',
  'Mckay',
  'Espinosa',
  'Rivers',
  'Farley',
  'Bernard',
  'Ashley',
  'Friedman',
  'Potts',
  'Truong',
  'Costa',
  'Correa',
  'Blevins',
  'Nixon',
  'Clements',
  'Fry',
  'Delarosa',
  'Best',
  'Benton',
  'Lugo',
  'Portillo',
  'Dougherty',
  'Crane',
  'Haley',
  'Phan',
  'Villalobos',
  'Blanchard',
  'Horne',
  'Finley',
  'Quintana',
  'Lynn',
  'Esquivel',
  'Bean',
  'Dodson',
  'Mullen',
  'Xiong',
  'Hayden',
  'Cano',
  'Levy',
  'Huber',
  'Richmond',
  'Moyer',
  'Lim',
  'Frye',
  'Sheppard',
  'Mccarty',
  'Avalos',
  'Booker',
  'Waller',
  'Parra',
  'Woodward',
  'Jaramillo',
  'Krueger',
  'Rasmussen',
  'Brandt',
  'Peralta',
  'Donaldson',
  'Stuart',
  'Faulkner',
  'Maynard',
  'Galindo',
  'Coffey',
  'Estes',
  'Sanford',
  'Burch',
  'Maddox',
  'Vo',
  'Oconnell',
  'Vu',
  'S',
  'S',
  'Andersen',
  'Spence',
  'Mcpherson',
  'Church',
  'Schmitt',
  'Stanton',
  'Leal',
  'Cherry',
  'Compton',
  'Dudley',
  'Sierra',
  'Pollard',
  'Alfaro',
  'Hester',
  'Proctor',
  'Lu',
  'Hinton',
  'Novak',
  'Good',
  'Madden',
  'Mccann',
  'Terrell',
  'Jarvis',
  'Dickson',
  'Reyna',
  'Cantrell',
  'Mayo',
  'Branch',
  'Hendrix',
  'Rollins',
  'Rowland',
  'Whitney',
  'Duke',
  'Odom',
  'Daugherty',
  'Travis',
  'Tang',
  "Danny"
}

return cfg
