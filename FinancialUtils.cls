/**
 * A utility class for financial calculations
 * 
 * 
 * Glossary: 
 *  pmt - calculated mortgage or annuity payment / yield per period.
 *  fv - future value of loan or annuity.
 *  nper - number of total payments / periods.
 *  pv - present value -- borrowed or invested principal.
 *  rate - periodic interest rate represented as a decimal.
 *  type - when payment is made: beginning of period is 1; end, 0.
 *  period - period (payment number) to check value at in formulas like PPMT or IPMT.
 *  method signature - procedure name, return type, parameters (typed or not).
 *  method overload(ing) - procedures whose signatures are same, except one or more parameters differ. 
 * 
 * * Reference: https://www.experts-exchange.com/articles/1948/A-Guide-to-the-PMT-FV-IPMT-and-PPMT-Functions.html
 * 
 * @author Jeff Douglas
 * @since 1/13/2022
 */

public with sharing class FinancialUtils {
  
    /**
     * Calculates the present value of an annuity investment based on constant-amount periodic
     * payments and a constant interest rate.
     * 
     * @param rate 
     * @param nper
     * @param pmt 
     * @return  `Double`
     */
    public static Double pv(Double rate, Double nper, Double pmt) {
        Double pv = 0;
        Boolean t = false;
        if (rate == 0) {
            pv = -1 * (nper * pmt);
        } else {
            Double r1 = rate + 1;
            pv = (( ( 1 - Math.pow(r1, nper) ) / rate ) * (t ? r1 : 1)  * pmt - 0) /Math.pow(r1, nper);
        }

        return pv;
    }

    /**
     * Calculates the periodic payment for an annuity investment based on constant-amount 
     * periodic payments and a constant interest rate.
     * 
     * @param rate 
     * @param nper 
     * @param pv 
     * @param fv 
     * @param type 
     * @return  `Double`
     */
    public static Double pmt(Double rate, Integer nper, Double pv, Double fv, Integer type) {
        Double pmt = rate / (Math.pow(1 + rate, nper) - 1) * -(pv * Math.pow(1 + rate, nper) + fv);
        
        return pmt;
    }

    /**
     * Calculates the future value of an annuity investment based on constant-amount periodic 
     * payments and a constant interest rate.
     * 
     * @param rate 
     * @param nper 
     * @param pmt 
     * @param pv 
     * @param type 
     * @return  `Double`
     */
    public static Double fv(Double rate, Integer nper, Double pmt, Double pv, Integer type) {
        Double fv = -(pmt * (Math.pow(1 + rate, nper) - 1) / rate + pv * Math.pow(1 + rate, nper));

        return fv;
    }

    /**
     * The interest portion of a future payment specified by the period argument
     * 
     * @param rate 
     * @param period
     * @param nper 
     * @param pv 
     * @param fv 
     * @param type 
     * @return  `Double`
     */
    public static Double ipmt(Double rate, Integer period, Integer nper, Double pv, Double fv, Integer type) {
        Double ipmt = fv(rate, period - 1, pmt(rate, nper, pv, fv, type), pv, type) * rate;
        if (type == 1) ipmt /= (1 + rate);
        
        return ipmt;
    }

    /**
     * Calculates the payment on the principal of an investment based on constant-amount periodic
     * payments and a constant interest rate.
     * 
     * @param rate 
     * @param period 
     * @param nper 
     * @param pv 
     * @param fv 
     * @param type 
     * @return  `Double`
     */
    public static Double ppmt(Double rate, Integer period, Integer nper, Double pv, Double fv, Integer type) {
        Double ppmt = pmt(rate, nper, pv, fv, type) - ipmt(rate, period, nper, pv, fv, type);

        return ppmt;
    }

}
