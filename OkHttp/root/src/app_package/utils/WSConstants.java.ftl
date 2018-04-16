package ${packageName}.utils;

public class WSConstants {

    public static int error_network = 1000;
    public static int error_io_exception = 10000;

    public static int success = 200;
    public static int error_bed_request = 400;
    public static int error_server = 500;
    public static int error_request_timeout = 408;
    public static int error_gateway_timeout = 504;


    public static String server_error_message = "Something is wrong, Please try after sometime.";
    public static String network_error_message = "There is no network connection at the moment, Please try again.";
    public static String time_out_error_message = "Sorry!!! Connection time out, please try again.";
    public static String bed_request_error_message = "The request could not be understood by the server due to malformed syntax, Please contact to admin.";

}