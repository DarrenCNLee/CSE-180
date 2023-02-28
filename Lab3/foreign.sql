ALTER TABLE
    Vehicles
ADD
    CONSTRAINT OwnerStateAndLicenseIDFK 
    FOREIGN KEY(ownerState, ownerLicenseID) REFERENCES Owners
        ON DELETE
        ON UPDATE CASCADE;

ALTER TABLE 
    Photos
ADD 
    CONSTRAINT VehicleStateAndLicensePlateFK
    FOREIGN KEY(vehicleState, vehicleLicensePlate) REFERENCES Vehicles 
        ON DELETE CASCADE
        ON UPDATE SET NULL;

ALTER TABLE
    Photos 
ADD 
    CONSTRAINT CameraIDFK
    FOREIGN KEY(cameraID) REFERENCES Cameras 
        ON DELETE CASCADE
        ON UPDATE RESTRICT;
        