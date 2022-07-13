/**
 * A small utility class for financial calculations
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

    private static Double FINANCIAL_PRECISION = 0.00000001; //1.0e-08
	private static Double FINANCIAL_MAX_ITERATIONS = 128;
     
    /**
     * Calculates the interest rate of an annuity investment based on constant-amount 
     * periodic payments and the assumption of a constant interest rate.
     * 
     * @param npr 
     * @param pmt 
     * @param pv 
     * @param fv 
     * @param type 
     * @return  `Double`
     */
    public static Double rate(Double npr, Double pmt, Double pv, Double fv, Integer type){
		Double rate = 0.1;
		Double y;
		Double f = 0.0;
		if (Math.abs(rate) < FINANCIAL_PRECISION) {
	        y = pv * (1 + npr * rate) + pmt * (1 + rate  * type) * npr + fv;
	    } else {
	        f = Math.exp(npr * Math.log(1 + rate));
	        y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
	    }
		
		Double y0 = pv + pmt * npr + fv;
	    Double y1 = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;

	    // find root by secant method
		Integer i = 0;
	    Double x0 = 0.0;
	    Double x1 = rate;
		while ((Math.abs(y0 - y1) > FINANCIAL_PRECISION) && (i < FINANCIAL_MAX_ITERATIONS)) {
			rate = (y1 * x0 - y0 * x1) / (y1 - y0);
			x0 = x1;
			x1 = rate;

			if (Math.abs(rate) < FINANCIAL_PRECISION) {
	            y = pv * (1 + npr * rate) + pmt * (1 + rate  * type) * npr + fv;
			} else {
				f = Math.exp(npr * Math.log(1 + rate));
				y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
			}

			y0 = y1;
			y1 = y;
			i++;
	    }
		return rate;
	}
  
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

        // account for payments at beginning of period versus end.
        if (type == 1) {
            pmt = pmt + (1 + rate);
        }
        
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