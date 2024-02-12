import { useState } from "react";
import { AxiosResponse } from "axios";
import { Room } from "../types/generated";
import { performRequestWithRetry } from "../api/retry";
import { apiUrl } from "../api/config";

export function useGetRooms() {
  const [rooms, setRooms] = useState<Room[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error>();

  const fetchRooms = async (
    checkIn: string,
    checkOut: string,
    roomType: string
  ): Promise<void> => {
    setLoading(true);
    const options = {
      method: "GET",
      params: {
        checkinDate: checkIn,
        checkoutDate: checkOut,
        roomType,
      },
    };
    try {
      const response = await performRequestWithRetry(
        `${apiUrl}/rooms`,
        options
      );
      const roomList = (response as AxiosResponse<Room[]>).data;
      setRooms(roomList);
    } catch (e: any) {
      setError(e);
    }
    setLoading(false);
  };

  return { rooms, loading, error, fetchRooms };
}
