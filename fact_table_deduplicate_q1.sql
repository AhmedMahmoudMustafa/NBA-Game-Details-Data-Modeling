INSERT INTO fact_device_events 
WITH deduped AS (
	
	SELECT
		e.event_time,
		e.user_id,
		d.*,
		ROW_NUMBER() OVER(PARTITION BY d.device_id, d.browser_type, d.device_type ORDER BY e.event_time) as row_num
FROM devices d JOIN events e 
		ON d.device_id = e.device_id
)

SELECT 
	    event_time::DATE AS dim_event_time,
		user_id    AS dim_user_id,
		device_id  AS dim_device_id,
		browser_type AS dim_browser_type,
		device_type  AS dim_device_type,
		os_type    AS dim_os_type,
	    browser_version_major AS m_browser_version_major,
		browser_version_minor AS m_browser_version_minor,
		browser_version_patch AS m_browser_version_patch,
		device_version_major  AS m_device_version_major,
		device_version_minor  AS m_device_version_minor,
		device_version_patch  AS m_device_version_patch,
		os_version_major AS m_os_version_major,
		os_version_minor AS m_os_version_minor,
		os_version_patch AS m_os_version_patch
FROM deduped 
WHERE row_num = 1 AND user_id IS NOT NULL


CREATE TABLE fact_device_events (
	
		dim_event_time DATE,
		dim_user_id NUMERIC,
		dim_device_id NUMERIC,
		dim_browser_type TEXT,
		dim_device_type TEXT,
		dim_os_type TEXT,
	    m_browser_version_major INTEGER,
		m_browser_version_minor INTEGER,
		m_browser_version_patch INTEGER,
		m_device_version_major TEXT,
		m_device_version_minor INTEGER,
		m_device_version_patch INTEGER,
		m_os_version_major TEXT,
		m_os_version_minor INTEGER,
		m_os_version_patch INTEGER,
		PRIMARY KEY (dim_event_time, dim_device_id, dim_browser_type)
);