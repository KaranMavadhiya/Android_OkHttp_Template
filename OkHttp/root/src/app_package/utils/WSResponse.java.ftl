package ${packageName}.utils;

public class WSResponse {
    
    private int statusCode;
    private String message;
    private String response;

    /**
     * @return statusCode
     */
    public int getStatusCode() {
        return statusCode;
    }

    /**
     * @param statusCode
     */
    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    /**
     * @return message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message message
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * @return response
     */
    public String getResponse() {
        return response;
    }

    /**
     * @param response response
     */
    public void setResponse(String response) {
        this.response = response;
    }
}