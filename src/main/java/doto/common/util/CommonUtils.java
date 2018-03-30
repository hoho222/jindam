package doto.common.util;

import java.util.UUID;

import org.springframework.stereotype.Component;

@Component("commonUtils")
public class CommonUtils {
	
	//저장되는 파일명을 랜덤 32글자로 변환
	public static String getRandomString(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
	
	//최소, 최대값 범위 내에서 랜덤 정수 1개 반환
	public static int randomRange(int min, int max) {
	    return (int) (Math.random() * (max - min + 1)) + min;
	}
	
	
	
}
