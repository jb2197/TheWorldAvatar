package uk.ac.cam.cares.jps.agent.weather;

import java.net.URI;
import java.time.Instant;

import javax.servlet.annotation.WebServlet;
import javax.ws.rs.BadRequestException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;

import uk.ac.cam.cares.jps.base.agent.JPSAgent;
import uk.ac.cam.cares.jps.base.exception.JPSRuntimeException;
import uk.ac.cam.cares.jps.base.query.RemoteStoreClient;
import uk.ac.cam.cares.jps.base.timeseries.TimeSeriesClient;

@WebServlet(urlPatterns = {"/DeleteStation"})
public class DeleteStation extends JPSAgent{

	private static final long serialVersionUID = 1L;
	// for logging
	private static final Logger LOGGER = LogManager.getLogger(DeleteStation.class);
	private WeatherQueryClient weatherClient = null;

	@Override
	public JSONObject processRequestParameters(JSONObject requestParams) {
        JSONObject response = new JSONObject();
    	
    	if (validateInput(requestParams)) {
			RemoteStoreClient storeClient = new RemoteStoreClient(Config.kgurl,Config.kgurl,Config.kguser,Config.kgpassword);
    		TimeSeriesClient<Instant> tsClient = new TimeSeriesClient<Instant>(storeClient, Instant.class, Config.dburl, Config.dbuser, Config.dbpassword);
    		
    		// replaced with mock client in the junit tests
    		if (weatherClient == null ) {
    			weatherClient = new WeatherQueryClient(storeClient, tsClient);
    		}
	    	
			String station = requestParams.getString("station");
			
			try {
				weatherClient.deleteStation(station);
				LOGGER.info("Deleted station: <" + station + ">");
			} catch (Exception e) {
				LOGGER.error("Delete station failed");
				throw new JPSRuntimeException(e);
			}
			response.put("status", "delete success");
    	}

    	return response;
	}
	
	@Override
	public boolean validateInput(JSONObject requestParams) {
		try {
			new URI(requestParams.getString("station"));
			return true;
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			throw new BadRequestException(e);
		}
	}

	/**
     * this setter is created purely for the purpose of junit testing where 
     * the weather client is replaced with a mock client that does not 
     * connect to the weather API
     * @param weatherClient
     */
    void setWeatherQueryClient(WeatherQueryClient weatherClient) {
    	this.weatherClient = weatherClient;
    }
}