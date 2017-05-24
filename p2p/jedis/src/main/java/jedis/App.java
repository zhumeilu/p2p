package jedis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * Hello world!
 *
 */
public class App {

	@Test
	public void testString() {
		Jedis j = new Jedis("localhost");
		String ret = j.set("hello", "hello jedis");
		System.out.println(ret);
		j.close();
	}

	@Test
	public void testGetString() {
		Jedis j = new Jedis("localhost");
		String ret = j.get("hello");
		System.out.println(ret);
		j.close();
	}

	@Test
	public void testIncr() {
		Jedis j = new Jedis("localhost");
		long currentId = j.incr("user:count");
		System.out.println(currentId);
		j.close();
	}

	@Test
	public void testList() {
		Jedis j = new Jedis("localhost");
		String key = "queue:1";
		List<String> ret = j.lrange(key, 0, -1);
		System.out.println(ret);

		long count = j.lpush(key, "add1", "add2", "add3");
		System.out.println(count);

		long count2 = j.llen(key);
		System.out.println(count2);

		ret = j.lrange(key, 0, -1);
		System.out.println(ret);

		j.close();
	}

	@Test
	public void testHash() {
		Jedis j = new Jedis("localhost");
		String key = "employee:1";

		Map<String, String> e = new HashMap<>();
		e.put("id", "1");
		e.put("name", "e");
		e.put("age", "18");

		String ret = j.hmset(key, e);
		System.out.println(ret);

		List<String> r = j.hmget(key, "age", "name");
		System.out.println(r);

		j.close();
	}

	private static JedisPool pool;

	public void initPool() {
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(1000);
		pool = new JedisPool(config, "localhost", 6379);
	}

	@Test
	public void testPool() {
		if (pool == null) {
			initPool();
		}
		Jedis j = null;
		try {
			j = pool.getResource();
			j.set("test", "testpool");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (j != null)
				pool.returnResourceObject(j);
		}
	}
	
	@Test
	public void testObj(){
		if (pool == null) {
			initPool();
		}
		Jedis j = null;
		try {
			User u=new User();
			u.setId(1L);
			u.setName("stef");
			j = pool.getResource();
			String key="user:"+u.getId();
			j.set(key.getBytes(), SerializeUtil.serialize(u));
			User u2=SerializeUtil.unserialize(j.get(key.getBytes()));
			System.out.println(u2);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (j != null)
				pool.returnResourceObject(j);
		}
	}
	
	
}
