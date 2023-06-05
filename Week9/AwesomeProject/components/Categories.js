import { View, Text, ScrollView } from "react-native";
import { useState, useEffect } from "react";
import React from "react";
import { getCategories } from "../api/categories";

export default function Categories() {
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    setCategories(getCategories());
  }, []);

  return (
    <View style={{ flex: 1, flexDirection: "column", marginTop: 20 }}>
      <ScrollView
        contentContainerStyle={{
          alignItems: "center",
          justifyContent: "center",
        }}
        style={{ flex: 1 }}
      >
        {categories.map((category) => (
          <View
            style={{
              backgroundColor: "#ffffff",
              padding: 20,
              marginBottom: 20,
              paddingHorizontal: 50,
            }}
            key={category.Id}
          >
            <Text>{category.Name}</Text>
            <Text>Description: {category.Description}</Text>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}
