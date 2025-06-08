CREATE TABLE ItemTypes (
    TypeID NUMBER PRIMARY KEY,
    TypeName VARCHAR2(10)
);

CREATE TABLE PetSpecies (
    SpeciesID NUMBER PRIMARY KEY,
    SpeciesName VARCHAR2(15)
);

CREATE TABLE PetColors (
    ColorID NUMBER PRIMARY KEY,
    ColorName VARCHAR2(15)
);

CREATE TABLE SpeciesColors (
    SpeciesID NUMBER NOT NULL,
    ColorID NUMBER NOT NULL,
    Is_Limited BOOLEAN DEFAULT FALSE,

PRIMARY KEY (SpeciesID, ColorID),
FOREIGN KEY (SpeciesID) REFERENCES PetSpecies(SpeciesID),
FOREIGN KEY (ColorID) REFERENCES PetColors(ColorID)
);

CREATE TABLE Players (
    UserID NUMBER PRIMARY KEY,
    Username VARCHAR2(20) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Passwordhash VARCHAR2(255) NOT NULL,
    JoinedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsBanned BOOLEAN DEFAULT FALSE
);

CREATE TABLE Pets (
    PetID NUMBER PRIMARY KEY,
    PetName VARCHAR2(20) NOT NULL,
    UserID NUMBER NOT NULL,
    SpeciesID NUMBER NOT NULL,
    ColorID NUMBER NOT NULL,
    CurrentLvl NUMBER DEFAULT 1 CHECK (CurrentLvl BETWEEN 1 and 50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

FOREIGN KEY (UserID) REFERENCES Players(UserID),
FOREIGN KEY (SpeciesID) REFERENCES PetSpecies(SpeciesID),
FOREIGN KEY (ColorID) REFERENCES PetColors (ColorID)
);

CREATE TABLE Items (
   ItemID NUMBER PRIMARY KEY,
    ItemName VARCHAR2(20) NOT NULL,
    ItemDesc VARCHAR2(100),
    ItemImageurl VARCHAR2(500),
    ItemType NUMBER NOT NULL,
    ItemRarity NUMBER NOT NULL,
    SellPrice NUMBER
);

CREATE TABLE PlayerInventory (
  InventoryID NUMBER PRIMARY KEY,
  PlayerID NUMBER NOT NULL,
  ItemID NUMBER NOT NULL,
  Quantity NUMBER DEFAULT 1 CHECK (Quantity >= 0),

FOREIGN KEY (PlayerID) REFERENCES Players(UserID),
FOREIGN KEY (ItemID) REFERENCES Items(ItemID),

  UNIQUE (PlayerID, ItemID)
);

CREATE SEQUENCE inventory_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE player_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE pet_seq
START WITH 1 
INCREMENT BY 1 
NOCACHE;

CREATE OR REPLACE TRIGGER trg_inventoryid
BEFORE INSERT ON PlayerInventory
FOR EACH ROW
BEGIN
  :NEW.InventoryID := inventory_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_player_id
BEFORE INSERT ON Players
FOR EACH ROW
WHEN (NEW.UserID IS NULL)
BEGIN
  SELECT player_seq.NEXTVAL INTO :NEW.UserID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_pet_id
BEFORE INSERT ON Pets
FOR EACH ROW
WHEN (NEW.PetID IS NULL)
BEGIN
    SELECT pet_seq.NEXTVAL INTO :NEW.PetID FROM dual;
END;
/

CREATE SEQUENCE species_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE color_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE item_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER trg_species_id
BEFORE INSERT ON PetSpecies
FOR EACH ROW
WHEN (NEW.SpeciesID IS NULL)
BEGIN
    SELECT species_seq.NEXTVAL INTO :NEW.SpeciesID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_color_id
BEFORE INSERT ON PetColors
FOR EACH ROW
WHEN (NEW.ColorID IS NULL)
BEGIN
    SELECT color_seq.NEXTVAL INTO :NEW.ColorID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_item_id
BEFORE INSERT ON Items
FOR EACH ROW
WHEN (NEW.ItemID IS NULL)
BEGIN
    SELECT item_seq.NEXTVAL INTO :NEW.ItemID FROM dual;
END;
/

INSERT INTO ItemTypes (TypeID, TypeName) VALUES (1, 'Food');

INSERT INTO ItemTypes (TypeID, TypeName) VALUES (2, 'Wearable');

INSERT INTO ItemTypes (TypeID, TypeName) VALUES (3, 'Book');

INSERT INTO ItemTypes (TypeID, TypeName) VALUES (4, 'Weapon');

INSERT INTO ItemTypes (TypeID, TypeName) VALUES (5, 'Material');

SELECT * FROM ITEMTYPES 

INSERT INTO PetSpecies (SpeciesName) VALUES ('Grumpkin');

INSERT INTO PetSpecies (SpeciesName) VALUES ('Snark');

INSERT INTO PetSpecies (SpeciesName) VALUES ('Beastie');

SELECT * FROM PetSpecies

INSERT INTO PetColors (ColorName) VALUES ('Blue');

INSERT INTO PetColors (ColorName) VALUES ('Black');

INSERT INTO PetColors (ColorName) VALUES ('Pink');

SELECT * FROM PetColors

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Grumpkin'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Blue'),
  FALSE
);

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Snark'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Blue'),
  FALSE
);

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Beastie'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Blue'),
  FALSE
);

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Grumpkin'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Black'),
  FALSE
);

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Snark'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Black'),
  FALSE
);

INSERT INTO SpeciesColors (SpeciesID, ColorID, Is_Limited)
VALUES (
  (SELECT SpeciesID FROM PetSpecies WHERE SpeciesName = 'Beastie'),
  (SELECT ColorID FROM PetColors WHERE ColorName = 'Pink'),
  TRUE
);

SELECT * FROM SpeciesColors

INSERT INTO Players (Username, Email, Passwordhash)
VALUES ('ChaosGremlin', 'test1@example.com', 'hashedpassword123');

INSERT INTO Players (Username, Email, Passwordhash)
VALUES ('CandyPunk', 'test@example.com', 'hashedpassword123');

INSERT INTO Players (Username, Email, Passwordhash)
VALUES ('KitterKat', 'test2@example.com', 'hashedpassword123');

SELECT * FROM Players

INSERT INTO Items (ItemName, ItemDesc, ItemImageurl, ItemType, ItemRarity, SellPrice)
VALUES ('Cornucopia', 'A veritable feast!', 'http://example.com/cornucopia.png', 1, 2, 10);

INSERT INTO Items (ItemName, ItemDesc, ItemImageurl, ItemType, ItemRarity, SellPrice)
VALUES ('Hero Cape', 'Capes are IN!', 'http://example.com/herocape.png', 2, 2, 10);

INSERT INTO Items (ItemName, ItemDesc, ItemImageurl, ItemType, ItemRarity, SellPrice)
VALUES ('Encyclopedia', 'Do people read these?', 'http://example.com/encyclopedia.png', 3, 2, 10);

INSERT INTO Items (ItemName, ItemDesc, ItemImageurl, ItemType, ItemRarity, SellPrice)
VALUES ('Chaos Sword', 'Gremlin energy unleashed.', 'http://example.com/chaossword.png', 4, 2, 10);

INSERT INTO Items (ItemName, ItemDesc, ItemImageurl, ItemType, ItemRarity, SellPrice)
VALUES ('Dog Bone', 'A tasty treat for dogs.', 'http://example.com/dogbone.png', 5, 2, 10);

CREATE OR REPLACE PROCEDURE pcd_newbie_pack(newUserID IN NUMBER) AS
BEGIN
  INSERT INTO PlayerInventory (UserID, ItemID, Quantity) VALUES
    (newUserID, 1, 5);

  INSERT INTO PlayerInventory (UserID, ItemID, Quantity) VALUES
    (newUserID, 2, 1);

  INSERT INTO PlayerInventory (UserID, ItemID, Quantity) VALUES
    (newUserID, 5, 10);
END;
/

CREATE OR REPLACE TRIGGER trg_newbie_pack
AFTER INSERT ON Players
FOR EACH ROW
BEGIN
  pcd_newbie_pack(:NEW.UserID);
END;
/

INSERT INTO Players (Username, Email, Passwordhash)
VALUES ('Challenger', 'test3@example.com', 'hashedpassword123');

SELECT * FROM Players
WHERE UserID = 3;

SELECT * FROM Items;

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('Asmeowdeus', 1, 1, 1);

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('ShereKhan', 2, 2, 1);

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('JoeJoe', 4, 3, 1);

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('Rowan', 4, 1, 2);

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('Orbliveon', 1, 2, 2);

INSERT INTO Pets (PetName, UserID, SpeciesID, ColorID)
VALUES ('Polyjamorous', 1, 3, 3);

INSERT INTO PlayerInventory (PlayerID, ItemID, Quantity)
VALUES (1, 1, 3);

INSERT INTO PlayerInventory (PlayerID, ItemID, Quantity)
VALUES (2, 4, 6);

INSERT INTO PlayerInventory (PlayerID, ItemID, Quantity)
VALUES (2, 5, 5);

INSERT INTO PlayerInventory (PlayerID, ItemID, Quantity)
VALUES (1, 5, 10);

INSERT INTO PlayerInventory (PlayerID, ItemID, Quantity)
VALUES (4, 3, 50);

SELECT * FROM Players;

CREATE VIEW PlayersView As
SELECT UserID, Username FROM Players;

SELECT * FROM PlayersView;

INSERT INTO Players (UserID, Username, Email, Passwordhash)
VALUES (3, 'NewPlayer', 'newplayer@example.com', 'hashedpassword123');

UPDATE PlayerInventory SET PlayerID = 3 WHERE PlayerID = (SELECT UserID FROM Players WHERE Username = 'Challenger');

UPDATE Players SET UserID = 3 WHERE UserName = 'Challenger';

DELETE FROM PlayerInventory WHERE PlayerID = 3;

ALTER TABLE PlayerInventory RENAME COLUMN PlayerID TO UserID;

SELECT * FROM PlayerInventory;

CREATE OR REPLACE VIEW player_summary AS
SELECT 
  Players.UserID AS player_id,
  Players.Username,
  COUNT(DISTINCT Pets.PetID) AS pet_count,
  COALESCE(SUM(PlayerInventory.Quantity), 0) AS total_items
FROM Players
LEFT JOIN Pets ON Pets.UserID = Players.UserID
LEFT JOIN PlayerInventory ON PlayerInventory.UserID = Players.UserID
GROUP BY Players.UserID, Players.Username
ORDER BY Players.UserID;

SELECT * FROM player_summary;