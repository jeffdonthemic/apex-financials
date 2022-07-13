/**
 * Units tests for FinancialUtils
 * 
 * These calculations were checked against the same functions in Google Sheets
 * 
 * @author Jeff Douglas
 * @since 1/13/2022
 */

@IsTest
private class FinancialUtils_Test {

    @IsTest static void testRate(){

        Integer nper = 24;
        Double pmt = 4000;
        Double pv = 90000;

        System.assertEquals(FinancialUtils.rate(nper, pmt, -pv, 0, 0), 0.005228827926420765);      
    }

    @IsTest static void testPv(){

        Double rate = 0.05;
        Double pmt = -1000;

        System.assertEquals(FinancialUtils.pv(rate, 24, pmt), 13798.641794347);     
        System.assertEquals(FinancialUtils.pv(rate, 36, pmt), 16546.85170756996); 
        System.assertEquals(FinancialUtils.pv(0, 24, pmt), 24000.0); 
    }

    @IsTest static void testPmt(){

        Double rate = 0.0520/12;
        Double pv = -88931.38;

        System.assertEquals(FinancialUtils.pmt(rate, 24, pv, 0, 0), 3909.5136186629875); 
        System.assertEquals(FinancialUtils.pmt(rate, 36, pv, 0, 0), 2673.3462222076455);     
        System.assertEquals(FinancialUtils.pmt(rate, 42, pv, 0, 0), 2320.5118273122516);
        System.assertEquals(FinancialUtils.pmt(rate, 48, pv, 0, 0), 2056.093633953784);
        System.assertEquals(FinancialUtils.pmt(rate, 60, pv, 0, 0), 1686.4057180374832);     
    }

    @IsTest static void testFv(){

        Double rate = 0.05;
        Double pmt = -1000.00;
        Double pv = 5000;

        System.assertEquals(FinancialUtils.fv(rate, 24, pmt, pv, 0), 28376.49915570554);   
        System.assertEquals(FinancialUtils.fv(rate, 36, pmt, pv, 0), 66877.24203957804);    
    }

    @IsTest static void testIpmt(){

        Double rate = 0.05;
        Double pv = -5000;
        Integer nper = 24;

        System.assertEquals(FinancialUtils.ipmt(rate, 1, nper, pv, 0, 0), 250.0);
        System.assertEquals(FinancialUtils.ipmt(rate, 2, nper, pv, 0, 0), 244.38227481182827);
        System.assertEquals(FinancialUtils.ipmt(rate, 3, nper, pv, 0, 0), 238.48366336424795);
    }

    @IsTest static void testPpmt(){

        Double rate = 0.05;
        Double pv = -5000;
        Integer nper = 24;

        System.assertEquals(FinancialUtils.ppmt(rate, 1, nper, pv, 0, 0), 112.35450376343493);
        System.assertEquals(FinancialUtils.ppmt(rate, 2, nper, pv, 0, 0), 117.97222895160667);
        System.assertEquals(FinancialUtils.ppmt(rate, 3, nper, pv, 0, 0), 123.87084039918699);
    }
    
}