package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.seasonal.SeasonalFoodDto;
import com.on_bapsang.backend.dto.seasonal.SeasonalFoodItem;
import com.on_bapsang.backend.dto.seasonal.SeasonalFoodResponse;
import com.on_bapsang.backend.entity.SeasonalFood;
import com.on_bapsang.backend.repository.SeasonalFoodRepository;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Unmarshaller;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.StringReader;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SeasonalFoodService {

    private final RestTemplate restTemplate;
    private final SeasonalFoodRepository foodRepository;

    public void fetchAndSaveFoods(int month) {
        String apiKey = "6f464a683f66b7c1b4fff9a85e09bcc2d2dc8e20893cc2e10df6fcb0b4cdfd67";
        String type = "xml";
        int start = 1;
        int end = 100;
        String monthStr = month + "월";

        String url = String.format(
                "http://211.237.50.150:7080/openapi/%s/xml/Grid_20171128000000000572_1/%d/%d?M_DISTCTNS=%s",
                apiKey, start, end, monthStr
        );


        try {
            String xml = restTemplate.getForObject(url, String.class);
            JAXBContext context = JAXBContext.newInstance(SeasonalFoodResponse.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            SeasonalFoodResponse response = (SeasonalFoodResponse) unmarshaller.unmarshal(new StringReader(xml));

            List<SeasonalFood> foods = response.getRows().stream()
                    .map(item -> {
                        SeasonalFood food = new SeasonalFood();
                        food.setIdntfcNo(Long.parseLong(item.getIDNTFC_NO()));
                        food.setPrdlstNm(item.getPRDLST_NM());
                        food.setMDistctns(item.getM_DISTCTNS());
                        food.setEffect(item.getEFFECT());
                        food.setPurchaseMth(item.getPURCHASE_MTH());
                        food.setCookMth(item.getCOOK_MTH());
                        food.setImgUrl(item.getIMG_URL());
                        return food;
                    }).collect(Collectors.toList());

            foodRepository.saveAll(foods);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("OpenAPI → DB 저장 실패: " + e.getMessage());
        }
    }

    public void fetchAndSaveAllMonths() {
        for (int month = 1; month <= 12; month++) {
            try {
                fetchAndSaveFoods(month);
            } catch (Exception e) {
                System.err.println(month + "월 데이터 저장 실패: " + e.getMessage());
            }
        }
    }

    public List<SeasonalFoodDto> getFoodsByMonth(String month) {
        return foodRepository.findBymDistctns(month + "월").stream()
                .map(food -> new SeasonalFoodDto(
                        food.getIdntfcNo(),
                        food.getPrdlstNm(),
                        food.getMDistctns(),
                        food.getEffect(),
                        food.getPurchaseMth(),
                        food.getCookMth(),
                        food.getImgUrl()
                ))
                .collect(Collectors.toList());
    }
}
