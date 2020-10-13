package com.company.dto.dtoEntites.graphEntities;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class GraphDTO
{
    private List<NodeDataDTO> nodes;
    private List<EdgeDataDTO> edges;
}
