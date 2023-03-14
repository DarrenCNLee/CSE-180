/**
 * runHighwayApplication skeleton, to be modified by students
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define MAXCONNECTIONSTRINGSIZE 501
/* Maximum length of string used to submit a SQL statement */
#define MAXSQLSTATEMENTSTRINGSIZE 2001
/* Maximum length of string version of integer; you don't have to use a value this big */
#define MAXNUMBERSTRINGSIZE 20

/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_FAILURE);
}

/* The three C functions that for Lab4 should appear below.
 * Write those functions, as described in Lab4 Section 4 (and Section 5,
 * which describes the Stored Function used by the third C function).
 *
 * Write the tests of those function in main, as described in Section 6
 * of Lab4.
 *
 * You may use "helper" functions to avoid having to duplicate calls and
 * printing, if you'd like, but if Lab4 says do things in a function, do them
 * in that function, and if Lab4 says do things in main, do them in main,
 * possibly using a helper function, if you'd like.
 */

/* Function: printCameraPhotoCount:
 * -------------------------------------
 * Parameters:  connection, and theCameraID, which should be the ID of a camera.
 * Prints the cameraID, the highwayNum and mileMarker of that camera, and the
 * number of number of photos for that camera, if camera exists for thecameraID.
 * Return 0 if normal execution, -1 if no such camera.
 * bad_exit if SQL statement execution fails.
 */

int printCameraPhotoCount(PGconn *conn, int theCameraID)
{
    PQexec(conn, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");

    // command to check if a camera with the theCameraID exists
    char doesCameraExist[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(doesCameraExist, "SELECT * FROM Cameras WHERE cameraID = %d;", theCameraID);

    PGresult *res = PQexec(conn, doesCameraExist);

    // check if executing the command worked
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        PQexec(conn, "ROLLBACK");
        PQclear(res);
        bad_exit(conn);
    }

    // if there is no camera in the Cameras table with cameraID equal to theCameraID
    if (PQntuples(res) <= 0)
    {
        PQexec(conn, "COMMIT;");
        PQclear(res);
        return -1;
    }

    // command to select the highway numbers, milemarkers, and number of tuples for cameras with theCameraID
    char command[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(command,
            "SELECT c.highwayNum, c.mileMarker, COUNT(*) FROM Cameras c, Photos p WHERE c.cameraID = %d AND c.cameraID = p.cameraID GROUP BY c.highwayNum, c.mileMarker;",
            theCameraID);

    // PQclear(res);
    res = PQexec(conn, command);

    // check if executing the command worked
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        PQexec(conn, "ROLLBACK");
        PQclear(res);
        bad_exit(conn);
    }

    // if there are no photos in the Photos table with cameraID equal to theCameraID
    if (PQntuples(res) == 0)
    {
        sprintf(command,
                "SELECT c.highwayNum, c.mileMarker FROM Cameras c WHERE c.cameraID = %d ;",
                theCameraID);
        // PQclear(res);
        res = PQexec(conn, command);
        // check if executing the command worked
        if (PQresultStatus(res) != PGRES_TUPLES_OK)
        {
            PQexec(conn, "ROLLBACK");
            PQclear(res);
            bad_exit(conn);
        }
        // the camera has taken 0 photos
        printf("Camera %d, on %s at %s has taken 0 photos.\n", theCameraID, PQgetvalue(res, 0, 0), PQgetvalue(res, 0, 1));
    }

    else
    {
        // print the cameraID, highwayNum, and mileMarker for that camera and the number of photos for that camera
        printf("Camera %d, on %s at %s has taken %s photos.\n", theCameraID, PQgetvalue(res, 0, 0), PQgetvalue(res, 0, 1), PQgetvalue(res, 0, 2));
    }

    PQexec(conn, "COMMIT;");
    // check if executing the command worked
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        PQclear(res);
        bad_exit(conn);
    }

    PQclear(res);
    PQfinish(conn);
    return 0;
}

/* Function: openAllExits:
 * ----------------------------
 * Parameters:  connection, and theHighwayNum, the number of a highway.

 * Opens all the exit on that highway that weren't already open.
 * Returns the number of exits on the highway that weren't open,
 * or -1 if there is no highway whose highwayNum is theHighwayNum.
 */

int openAllExits(PGconn *conn, int theHighwayNum)
{
    PQexec(conn, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");

    // command to check if a highway exists with theHighwayNum
    char doesHighwayExist[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(doesHighwayExist,
            "SELECT * FROM Highways WHERE highwayNum = %d;",
            theHighwayNum);

    PGresult *check = PQexec(conn, doesHighwayExist);

    // if there is no highway with theHighwayNum, return -1
    if (PQntuples(check) <= 0)
    {
        PQexec(conn, "COMMIT;");
        PQclear(check);
        return -1;
    }

    // command to update the Exits table by opening all exits that were not open already
    char command[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(command,
            "UPDATE Exits SET isExitOpen = TRUE WHERE highwayNum = %d AND (isExitOpen = FALSE OR isExitOpen IS NULL);",
            theHighwayNum);

    PQexec(conn, "COMMIT;");

    PGresult *res = PQexec(conn, command);

    // return the number of exits that were updated
    int numExits = atoi(PQcmdTuples(res));
    PQclear(check);
    PQclear(res);
    return numExits;
}

/* Function: determineSpeedingViolationsAndFines:
 * -------------------------------
 * Parameters:  connection, and an integer maxFineTotal, the maximum total
 * of the fines that should be assessed to owners whose vehicles were speeding.
 *
 * It should count the number of speeding violations by vehicles that each owner
 * owns, and set the speedingViolations field of Owners accordingly.
 *
 * It should also assess fines to some owners based on the number of speeding
 * violations they have.
 *
 * Executes by invoking a Stored Function,
 * determineSpeedingViolationsAndFinesFunction, which does all of the work,
 * as described in Section 5 of Lab4.
 *
 * Returns a negative value if there is an error, and otherwise returns the total
 * fines that were assessed by the Stored Function.
 */

int determineSpeedingViolationsAndFines(PGconn *conn, int maxFineTotal)
{

    // command to call teh determineSpeedingViolationsAndFinesFunction function
    char command[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(command,
            "SELECT determineSpeedingViolationsAndFinesFunction(%d)",
            maxFineTotal);

    PGresult *res = PQexec(conn, command);

    // return a negative value if there was an error
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        PQclear(res);
        return -1;
    }

    // return the total fines assessed
    int totalFines = atoi(PQgetvalue(res, 0, 0));
    PQclear(res);
    return totalFines;
}

int main(int argc, char **argv)
{
    PGconn *conn;
    int theResult;

    if (argc != 3)
    {
        fprintf(stderr, "Usage: ./runHighwayApplication <username> <password>\n");
        exit(EXIT_FAILURE);
    }

    char *userID = argv[1];
    char *pwd = argv[2];

    char conninfo[MAXCONNECTIONSTRINGSIZE] = "host=cse180-db.lt.ucsc.edu user=";
    strcat(conninfo, userID);
    strcat(conninfo, " password=");
    strcat(conninfo, pwd);

    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);

    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n",
                PQerrorMessage(conn));
        bad_exit(conn);
    }

    int result;

    /* Perform the calls to printCameraPhotoCount listed in Section 6 of Lab4,
     * printing error message if there's an error.
     */

    int cameraID;
    // test camera with id 951
    cameraID = 951;
    result = printCameraPhotoCount(conn, cameraID);
    if (result == -1)
    {
        printf("No camera exists whose id is %d\n", cameraID);
    }
    else if (result != 0)
    {
        printf("Error in printCameraPhotoCount function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test camera with id 960
    cameraID = 960;
    result = printCameraPhotoCount(conn, cameraID);
    if (result == -1)
    {
        printf("No camera exists whose id is %d\n", cameraID);
    }
    else if (result != 0)
    {
        printf("Error in printCameraPhotoCount function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test camera with id 856
    cameraID = 856;
    result = printCameraPhotoCount(conn, cameraID);
    if (result == -1)
    {
        printf("No camera exists whose id is %d\n", cameraID);
    }
    else if (result != 0)
    {
        printf("Error in printCameraPhotoCount function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test camera with id 905
    cameraID = 904;
    result = printCameraPhotoCount(conn, cameraID);
    if (result == -1)
    {
        printf("No camera exists whose id is %d\n", cameraID);
    }
    else if (result != 0)
    {
        printf("Error in printCameraPhotoCount function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    /* Extra newline for readability */
    printf("\n");

    /* Perform the calls to openAllExits listed in Section 6 of Lab4,
     * and print messages as described.
     */

    int highwayNum;
    // test highway with highwayNum 101
    highwayNum = 101;
    result = openAllExits(conn, highwayNum);
    if (result >= 0)
    {
        printf("%d exits were opened by openAllExits\n", result);
    }

    else if (result == -1)
    {
        printf("There is no highway whose number is %d\n", highwayNum);
    }

    else
    {
        printf("Error in openAllExits function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test highway with highwayNum 13
    highwayNum = 13;
    result = openAllExits(conn, highwayNum);
    if (result >= 0)
    {
        printf("%d exits were opened by openAllExits\n", result);
    }

    else if (result == -1)
    {
        printf("There is no highway whose number is %d\n", highwayNum);
    }

    else
    {
        printf("Error in openAllExits function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test highway with highwayNum 280
    highwayNum = 280;
    result = openAllExits(conn, highwayNum);
    if (result >= 0)
    {
        printf("%d exits were opened by openAllExits\n", result);
    }

    else if (result == -1)
    {
        printf("There is no highway whose number is %d\n", highwayNum);
    }

    else
    {
        printf("Error in openAllExits function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    // test highway with highwayNum 904
    highwayNum = 17;
    result = openAllExits(conn, highwayNum);
    if (result >= 0)
    {
        printf("%d exits were opened by openAllExits\n", result);
    }

    else if (result == -1)
    {
        printf("There is no highway whose number is %d\n", highwayNum);
    }

    else
    {
        printf("Error in openAllExits function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }

    /* Extra newline for readability */
    printf("\n");

    /* Perform the calls to determineSpeedingViolationsAndFines listed in Section
     * 6 of Lab4, and print messages as described.
     * You may use helper functions to do this, if you want.
     */

    int maxFineTotal;
    // test with maxFinetotal of 300
    maxFineTotal = 300;
    result = determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (result < 0)
    {
        printf("Error in determineSpeedingViolationsAndFines function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }
    printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, result);

    // test with maxFinetotal of 240
    maxFineTotal = 240;
    result = determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (result < 0)
    {
        printf("Error in determineSpeedingViolationsAndFines function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }
    printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, result);

    // test with maxFinetotal of 210
    maxFineTotal = 210;
    result = determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (result < 0)
    {
        printf("Error in determineSpeedingViolationsAndFines function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }
    printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, result);

    // test with maxFinetotal of 165
    maxFineTotal = 165;
    result = determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (result < 0)
    {
        printf("Error in determineSpeedingViolationsAndFines function. Bad value returned: %d\n", result);
        bad_exit(conn);
    }
    printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, result);

    good_exit(conn);
    return 0;
}
