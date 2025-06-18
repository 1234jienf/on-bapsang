package com.on_bapsang.backend.dto.mypage;

import com.on_bapsang.backend.dto.RecipeSummaryDto;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class ScrappedRecipeResponse {
    private int currentPage;
    private boolean hasMore;
    private List<RecipeSummaryDto> data;
}
