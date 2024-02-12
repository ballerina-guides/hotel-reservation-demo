import React from "react";
import { Room } from "../../types/generated";
import { Box, Button, Typography } from "@mui/material";
import LuggageOutlinedIcon from "@mui/icons-material/LuggageOutlined";
import { useNavigate } from "react-router-dom";

export default function RoomListItem(props: { room: Room }) {
  const { room } = props;
  const navigate = useNavigate();
  return (
    <Box
      style={{ background: "white" }}
      display="flex"
      justifyContent="space-between"
      width="100%"
      border={1}
      borderRadius={4}
      mb={1}
    >
      <Box
        width="13%"
        p={2}
        pl={4}
        display="flex"
        flexDirection="column"
        justifyContent="center"
        alignItems="flex=start"
      >
        <Box>
          <Typography variant="h6" color="grey">{room.type.name}</Typography>
        </Box>
        <Box display="flex" justifyContent="flex-start" alignItems="center">
          <Box>
            <LuggageOutlinedIcon />
          </Box>
          <Box>
            <Typography fontSize={12}>
              {room.type.guestCapacity} Guests
            </Typography>
          </Box>
        </Box>
      </Box>

      <Box
        width="53%"
        p={2}
        display="flex"
        flexDirection="column"
        justifyContent="center"
        alignItems="center"
      >
        <Typography>Room: {room.number}</Typography>
      </Box>

      <Box
        width="13%"
        p={2}
        display="flex"
        flexDirection="column"
        justifyContent="center"
        alignItems="flex-end"
      >
        <Typography>{room.type.price}$ /day</Typography>
      </Box>

      <Box
        width="13%"
        p={2}
        pr={4}
        display="flex"
        flexDirection="column"
        justifyContent="flex-end"
        alignItems="center"
      >
        <Button
          onClick={() => {
            navigate("/reservations/new", { state: { room } });
          }}
          style={{ textTransform: "none" }}
          variant="contained"
        >
          Reserve
        </Button>
      </Box>
    </Box>
  );
}
